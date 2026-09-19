import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/winxp_window_frame.dart';

/// Windows XP 순정 지뢰찾기 (Minesweeper)
class WinXpMinesweeperWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const WinXpMinesweeperWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 280,
    this.height = 360,
    this.isMaximized = false,
  });

  @override
  State<WinXpMinesweeperWindow> createState() => _WinXpMinesweeperWindowState();
}

enum _CellState { covered, revealed, flagged }
enum _GameStatus { ready, playing, won, lost }

class _WinXpMinesweeperWindowState extends State<WinXpMinesweeperWindow> {
  static const int rows = 9;
  static const int cols = 9;
  static const int totalMines = 10;

  late List<List<bool>> _mines;
  late List<List<_CellState>> _cellStates;
  late List<List<int>> _neighborCounts;

  _GameStatus _gameStatus = _GameStatus.ready;
  bool _isFacePressed = false;
  bool _isCellPressed = false;

  int _flagCount = 0;
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startNewGame() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _gameStatus = _GameStatus.ready;
    _flagCount = 0;

    _mines = List.generate(rows, (_) => List.generate(cols, (_) => false));
    _cellStates = List.generate(rows, (_) => List.generate(cols, (_) => _CellState.covered));
    _neighborCounts = List.generate(rows, (_) => List.generate(cols, (_) => 0));

    setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameStatus == _GameStatus.playing) {
        setState(() {
          if (_secondsElapsed < 999) {
            _secondsElapsed++;
          }
        });
      }
    });
  }

  void _generateMines(int firstR, int firstC) {
    final random = Random();
    int placed = 0;

    while (placed < totalMines) {
      final r = random.nextInt(rows);
      final c = random.nextInt(cols);

      // 첫 클릭 위치 및 그 주변 3x3은 안전 영역
      if ((r - firstR).abs() <= 1 && (c - firstC).abs() <= 1) continue;
      if (_mines[r][c]) continue;

      _mines[r][c] = true;
      placed++;
    }

    // 주변 지뢰 개수 계산
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (_mines[r][c]) continue;
        int count = 0;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            final nr = r + dr;
            final nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && _mines[nr][nc]) {
              count++;
            }
          }
        }
        _neighborCounts[r][c] = count;
      }
    }
  }

  void _revealCell(int r, int c) {
    if (_gameStatus == _GameStatus.won || _gameStatus == _GameStatus.lost) return;
    if (_cellStates[r][c] == _CellState.flagged) return;

    if (_gameStatus == _GameStatus.ready) {
      _generateMines(r, c);
      _gameStatus = _GameStatus.playing;
      _startTimer();
    }

    // 지뢰 밟음 -> 게임 오버
    if (_mines[r][c]) {
      _timer?.cancel();
      setState(() {
        _gameStatus = _GameStatus.lost;
        // 모든 지뢰 공개
        for (int i = 0; i < rows; i++) {
          for (int j = 0; j < cols; j++) {
            if (_mines[i][j]) {
              _cellStates[i][j] = _CellState.revealed;
            }
          }
        }
      });
      return;
    }

    // 안전 셀 공개 (BFS flood fill)
    _floodFill(r, c);

    // 승리 검증
    _checkWinCondition();
  }

  void _floodFill(int startR, int startC) {
    final queue = <Point<int>>[Point(startR, startC)];

    while (queue.isNotEmpty) {
      final p = queue.removeAt(0);
      final r = p.x;
      final c = p.y;

      if (_cellStates[r][c] == _CellState.revealed) continue;
      _cellStates[r][c] = _CellState.revealed;

      if (_neighborCounts[r][c] == 0 && !_mines[r][c]) {
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            final nr = r + dr;
            final nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (_cellStates[nr][nc] == _CellState.covered) {
                queue.add(Point(nr, nc));
              }
            }
          }
        }
      }
    }
    setState(() {});
  }

  void _toggleFlag(int r, int c) {
    if (_gameStatus == _GameStatus.won || _gameStatus == _GameStatus.lost) return;
    if (_cellStates[r][c] == _CellState.revealed) return;

    setState(() {
      if (_cellStates[r][c] == _CellState.covered) {
        if (_flagCount < totalMines) {
          _cellStates[r][c] = _CellState.flagged;
          _flagCount++;
        }
      } else if (_cellStates[r][c] == _CellState.flagged) {
        _cellStates[r][c] = _CellState.covered;
        _flagCount--;
      }
    });

    _checkWinCondition();
  }

  void _checkWinCondition() {
    int unrevealedSafe = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!_mines[r][c] && _cellStates[r][c] != _CellState.revealed) {
          unrevealedSafe++;
        }
      }
    }

    if (unrevealedSafe == 0) {
      _timer?.cancel();
      setState(() {
        _gameStatus = _GameStatus.won;
        _flagCount = totalMines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WinXpWindowFrame(
      title: '지뢰찾기',
      iconAsset: 'assets/images/windows/desk.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFFBDBDBD),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // 상단 메뉴바 (게임, 도움말)
            Row(
              children: [
                _buildMenuItem('게임(G)'),
                _buildMenuItem('도움말(H)'),
              ],
            ),
            const SizedBox(height: 6),

            // 지뢰찾기 상단 디스플레이 헤더 (음각 3D 테두리)
            _buildInsetBorder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 남은 지뢰 LCD 카운터
                  _buildDigitalLcd((totalMines - _flagCount).clamp(0, 999)),

                  // 중앙 스마일리 얼굴 버튼
                  _buildSmileyButton(),

                  // 소요 시간 LCD 카운터
                  _buildDigitalLcd(_secondsElapsed),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 9x9 지뢰 격자판
            Expanded(
              child: _buildInsetBorder(
                padding: const EdgeInsets.all(3),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: rows * cols,
                  itemBuilder: (context, index) {
                    final r = index ~/ cols;
                    final c = index % cols;
                    return _buildCell(r, c);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
      ),
    );
  }

  Widget _buildDigitalLcd(int number) {
    final str = number.toString().padLeft(3, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      color: Colors.black,
      child: Text(
        str,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF0000),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSmileyButton() {
    String emoji = '🙂';
    if (_gameStatus == _GameStatus.lost) {
      emoji = '😵';
    } else if (_gameStatus == _GameStatus.won) {
      emoji = '😎';
    } else if (_isCellPressed || _isFacePressed) {
      emoji = '😮';
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isFacePressed = true),
      onTapUp: (_) {
        setState(() => _isFacePressed = false);
        _startNewGame();
      },
      onTapCancel: () => setState(() => _isFacePressed = false),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFC0C0C0),
          border: _isFacePressed
              ? const Border(
                  top: BorderSide(color: Color(0xFF7B7B7B), width: 2),
                  left: BorderSide(color: Color(0xFF7B7B7B), width: 2),
                  right: BorderSide(color: Colors.white, width: 2),
                  bottom: BorderSide(color: Colors.white, width: 2),
                )
              : const Border(
                  top: BorderSide(color: Colors.white, width: 2),
                  left: BorderSide(color: Colors.white, width: 2),
                  right: BorderSide(color: Color(0xFF7B7B7B), width: 2),
                  bottom: BorderSide(color: Color(0xFF7B7B7B), width: 2),
                ),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildCell(int r, int c) {
    final state = _cellStates[r][c];

    if (state == _CellState.revealed) {
      if (_mines[r][c]) {
        // 폭발 지뢰
        return Container(
          color: const Color(0xFFFF0000),
          alignment: Alignment.center,
          child: const Text('💣', style: TextStyle(fontSize: 13)),
        );
      } else {
        // 숫자 셀
        final count = _neighborCounts[r][c];
        return Container(
          color: const Color(0xFFC0C0C0),
          alignment: Alignment.center,
          child: count > 0
              ? Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _getNumberColor(count),
                  ),
                )
              : null,
        );
      }
    }

    // 덮여 있는 셀 (Beveled 3D)
    return GestureDetector(
      onTapDown: (_) => setState(() => _isCellPressed = true),
      onTapUp: (_) => setState(() => _isCellPressed = false),
      onTapCancel: () => setState(() => _isCellPressed = false),
      onTap: () => _revealCell(r, c),
      onSecondaryTap: () => _toggleFlag(r, c),
      onLongPress: () => _toggleFlag(r, c),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFC0C0C0),
          border: Border(
            top: BorderSide(color: Colors.white, width: 2),
            left: BorderSide(color: Colors.white, width: 2),
            right: BorderSide(color: Color(0xFF7B7B7B), width: 2),
            bottom: BorderSide(color: Color(0xFF7B7B7B), width: 2),
          ),
        ),
        alignment: Alignment.center,
        child: state == _CellState.flagged
            ? const Text('🚩', style: TextStyle(fontSize: 12))
            : null,
      ),
    );
  }

  Color _getNumberColor(int count) {
    switch (count) {
      case 1:
        return const Color(0xFF0000FF); // 파랑
      case 2:
        return const Color(0xFF008000); // 초록
      case 3:
        return const Color(0xFFFF0000); // 빨강
      case 4:
        return const Color(0xFF000080); // 남색
      case 5:
        return const Color(0xFF800000); // 갈색
      case 6:
        return const Color(0xFF008080); // 틸
      case 7:
        return Colors.black;
      default:
        return const Color(0xFF808080);
    }
  }

  Widget _buildInsetBorder({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Color(0xFF7B7B7B), width: 2.5),
          left: BorderSide(color: Color(0xFF7B7B7B), width: 2.5),
          right: BorderSide(color: Colors.white, width: 2.5),
          bottom: BorderSide(color: Colors.white, width: 2.5),
        ),
      ),
      child: child,
    );
  }
}

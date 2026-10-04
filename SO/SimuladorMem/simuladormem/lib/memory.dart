import 'package:flutter/material.dart';

class Process {
  final String name;
  final int size;
  final Color color;

  Process({required this.name, required this.size, required this.color});
}

enum FitType { firstFit, worstFit }

class MemoryBlock {
  int start;
  int size;
  bool isFree;
  Process? process;
  late MemoryBlock next;

  MemoryBlock({
    required this.start,
    required this.size,
    this.isFree = true,
    this.process,
    MemoryBlock? next,
  }) {
    this.next = next ?? this;
  }
}

class MemoryManager {
  static const int totalSize = 256;
  final MemoryBlock head;
  final List<Process> _processes = [];

  MemoryManager() : head = MemoryBlock(start: 0, size: totalSize);

  List<Process> get processes => List.unmodifiable(_processes);

  bool allocate(Process process, FitType fitType) {
    if (process.size <= 0 || process.size > totalSize) return false;

    MemoryBlock? target;
    MemoryBlock? targetPrev;

    MemoryBlock prev = head;
    while (prev.next != head) {
      prev = prev.next;
    }

    MemoryBlock current = head;
    do {
      if (current.isFree && current.size >= process.size) {
        bool select = false;
        if (target == null) {
          select = true;
        } else if (fitType == FitType.worstFit &&
            current.size > target.size) {
          select = true;
        }

        if (select) {
          target = current;
          targetPrev = prev;
          if (fitType == FitType.firstFit) break;
        }
      }
      prev = current;
      current = current.next;
    } while (current != head);

    if (target == null) return false;

    if (target.size == process.size) {
      target.isFree = false;
      target.process = process;
    } else {
      final allocated = MemoryBlock(
        start: target.start,
        size: process.size,
        isFree: false,
        process: process,
        next: target,
      );
      target.start += process.size;
      target.size -= process.size;
      targetPrev!.next = allocated;
    }

    _processes.add(process);
    return true;
  }

  bool deallocate(Process process) {
    MemoryBlock current = head;
    do {
      if (!current.isFree && current.process == process) {
        current.isFree = true;
        current.process = null;
        _processes.remove(process);
        return true;
      }
      current = current.next;
    } while (current != head);
    return false;
  }

  void coalesce() {
    MemoryBlock current = head;
    do {
      if (current.isFree) {
        while (current.next != head && current.next.isFree) {
          current.size += current.next.size;
          current.next = current.next.next;
        }
      }
      current = current.next;
    } while (current != head);
  }

  List<Color> getGridColors() {
    final colors = List.filled(totalSize, Colors.black);
    MemoryBlock current = head;
    do {
      if (!current.isFree && current.process != null) {
        for (int i = current.start;
            i < current.start + current.size && i < totalSize;
            i++) {
          colors[i] = current.process!.color;
        }
      }
      current = current.next;
    } while (current != head);
    return colors;
  }
}

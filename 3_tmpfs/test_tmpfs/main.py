import os
import time
from pathlib import Path

FILE_SIZE = 128 * 1024 * 1024
BLOCK_SIZE = 1024 * 1024


def benchmark(path):
    path = Path(path)
    path.mkdir(parents=True, exist_ok=True)

    test_file = path / "benchmark_test.dat"
    block = os.urandom(BLOCK_SIZE)

    try:
        # Mesurar velocitat d'escriptura
        start = time.perf_counter()

        with open(test_file, "wb") as f:
            for _ in range(FILE_SIZE // BLOCK_SIZE):
                f.write(block)

            f.flush()
            os.fsync(f.fileno())

        write_time = time.perf_counter() - start

        # Mesurar velocitat de lectura
        start = time.perf_counter()

        with open(test_file, "rb") as f:
            while f.read(BLOCK_SIZE):
                pass

        read_time = time.perf_counter() - start

        return write_time, read_time

    finally:
        test_file.unlink(missing_ok=True)


def relation_aspect(normal_result, tmpfs_result):
    return (
        normal_result[0] / tmpfs_result[0],
        normal_result[1] / tmpfs_result[1]
    )


def main():
    normal_path = Path.home() / "benchmark_disk"
    tmpfs_path = "/mnt/prac3_tmpfs"

    print("Iniciant benchmark de 128 MiB...\n")

    normal_result = benchmark(normal_path)
    tmpfs_result = benchmark(tmpfs_path)

    write_ratio, read_ratio = relation_aspect(
        normal_result, tmpfs_result
    )

    print(f"Disc normal - Escriptura: {normal_result[0]:.4f} s")
    print(f"Disc normal - Lectura:    {normal_result[1]:.4f} s")

    print(f"Tmpfs - Escriptura:       {tmpfs_result[0]:.4f} s")
    print(f"Tmpfs - Lectura:          {tmpfs_result[1]:.4f} s")

    print(f"\nRelacio escriptura: {write_ratio:.2f}x")
    print(f"Relacio lectura:    {read_ratio:.2f}x")


if __name__ == "__main__":
    main()


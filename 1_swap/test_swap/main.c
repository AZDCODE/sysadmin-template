#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BLOCK_SIZE (64UL * 1024 * 1024)
#define MAX_BLOCKS 80

int main(void) {
    char *blocks[MAX_BLOCKS] = {0};
    int allocated = 0;

    printf("Iniciant prova de memoria i swap...\n");

    for (int i = 0; i < MAX_BLOCKS; i++) {
        blocks[i] = malloc(BLOCK_SIZE);

        if (blocks[i] == NULL) {
            printf("No es pot reservar mes memoria.\n");
            break;
        }

        memset(blocks[i], 1, BLOCK_SIZE);
        allocated++;

        printf("Memoria reservada: %d MiB\n", allocated * 64);
        fflush(stdout);

        sleep(1);
    }

    printf("\nReserva finalitzada. Prem Enter per alliberar memoria.\n");
    getchar();

    for (int i = 0; i < allocated; i++) {
        free(blocks[i]);
    }

    printf("Memoria alliberada.\n");

    return 0;
}

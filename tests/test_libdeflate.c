#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libdeflate.h>

int main() {
    printf("libdeflate version: %s\n", LIBDEFLATE_VERSION_STRING);

    // Simple compression test
    const char *input = "Hello, libdeflate!";
    size_t input_size = strlen(input);
    size_t max_compressed_size = libdeflate_gzip_compress_bound(NULL, input_size);
    
    uint8_t *compressed = malloc(max_compressed_size);
    if (!compressed) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    struct libdeflate_compressor *compressor = libdeflate_alloc_compressor(6);
    if (!compressor) {
        fprintf(stderr, "Failed to allocate compressor\n");
        free(compressed);
        return 1;
    }

    size_t compressed_size = libdeflate_gzip_compress(compressor, input, input_size, compressed, max_compressed_size);
    if (compressed_size == 0) {
        fprintf(stderr, "Compression failed\n");
        libdeflate_free_compressor(compressor);
        free(compressed);
        return 1;
    }

    printf("Compression successful. Input size: %zu, Compressed size: %zu\n", input_size, compressed_size);

    libdeflate_free_compressor(compressor);
    free(compressed);
    return 0;
}
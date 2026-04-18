#include <stdint.h>

// Trick to avoid conflicts with system headers for the functions we must override with specific signatures
#define __wasi_path_open __wasi_path_open_skip

#include <wasi/api.h>
#include <emscripten.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#undef __wasi_path_open

// Data symbols for Crystal
#undef errno
int errno = 0;
int seed = 0;
int threads = 0;

_Noreturn void __wasi_proc_exit(__wasi_exitcode_t code) {
  exit(code);
}

// Bridge WASI functions to Emscripten FS using EM_ASM to avoid recursion
__wasi_errno_t __wasi_fd_write(__wasi_fd_t fd, const __wasi_ciovec_t *iovs, size_t iovs_len, __wasi_size_t *nwritten) {
  size_t total = 0;
  for (size_t i = 0; i < iovs_len; i++) {
    if (iovs[i].buf_len > 0) {
        int res = MAIN_THREAD_EM_ASM_INT({
          try {
            return FS.write(FS.getStream($0), HEAPU8.subarray($1, $1 + $2), 0, $2);
          } catch (e) {
            return -1;
          }
        }, fd, iovs[i].buf, iovs[i].buf_len);
        if (res < 0) return 5;
        total += res;
    }
  }
  *nwritten = (__wasi_size_t)total;
  return 0;
}

__wasi_errno_t __wasi_fd_read(__wasi_fd_t fd, const __wasi_iovec_t *iovs, size_t iovs_len, __wasi_size_t *nread) {
  size_t total = 0;
  for (size_t i = 0; i < iovs_len; i++) {
    if (iovs[i].buf_len > 0) {
        int res = MAIN_THREAD_EM_ASM_INT({
          try {
            return FS.read(FS.getStream($0), HEAPU8.subarray($1, $1 + $2), 0, $2);
          } catch (e) {
            return -1;
          }
        }, fd, iovs[i].buf, iovs[i].buf_len);
        if (res < 0) return 5;
        total += res;
        if (res < iovs[i].buf_len) break;
    }
  }
  *nread = (__wasi_size_t)total;
  return 0;
}

__wasi_errno_t __wasi_fd_close(__wasi_fd_t fd) {
  int res = MAIN_THREAD_EM_ASM_INT({
    try {
      FS.close(FS.getStream($0));
      return 0;
    } catch (e) {
      return -1;
    }
  }, fd);
  return res == 0 ? 0 : 5;
}

__wasi_errno_t __wasi_fd_seek(__wasi_fd_t fd, __wasi_filedelta_t offset, __wasi_whence_t whence, __wasi_filesize_t *newoffset) {
  double res = MAIN_THREAD_EM_ASM_DOUBLE({
    try {
      return FS.llseek(FS.getStream($0), $1, $2);
    } catch (e) {
      return -1;
    }
  }, fd, (double)offset, whence);
  if (res < 0) return 5;
  *newoffset = (__wasi_filesize_t)res;
  return 0;
}

// Crystal's 8-parameter version of path_open
__wasi_errno_t __wasi_path_open(__wasi_fd_t fd, __wasi_lookupflags_t dirflags, const char *path, __wasi_size_t path_len, __wasi_rights_t fs_rights_base, __wasi_rights_t fs_rights_inheriting, __wasi_fdflags_t fdflags, __wasi_fd_t *opened_fd) {
  int res = MAIN_THREAD_EM_ASM_INT({
    try {
      const path = UTF8ArrayToString(HEAPU8, $0, $1);
      const flags = ($2 & 1) ? 'a' : 'r';
      const stream = FS.open(path, flags);
      return stream.fd;
    } catch (e) {
      return -e.errno;
    }
  }, path, path_len, fdflags);
  if (res < 0) {
    if (res == -2) return 44; // NOENT
    return 5;
  }
  *opened_fd = res;
  return 0;
}

__wasi_errno_t __wasi_fd_fdstat_get(__wasi_fd_t fd, __wasi_fdstat_t *stat) {
  memset(stat, 0, sizeof(*stat));
  return 0;
}

__wasi_errno_t __wasi_environ_sizes_get(__wasi_size_t *count, __wasi_size_t *buf_size) {
  *count = 0;
  *buf_size = 0;
  return 0;
}
__wasi_errno_t __wasi_environ_get(uint8_t **environ, uint8_t *environ_buf) { return 0; }

__wasi_errno_t __wasi_clock_time_get(__wasi_clockid_t id, __wasi_timestamp_t precision, __wasi_timestamp_t *time) {
  *time = (uint64_t)emscripten_get_now() * 1000000ULL;
  return 0;
}

__wasi_errno_t __wasi_args_get(uint8_t **argv, uint8_t *argv_buf) { return 0; }
__wasi_errno_t __wasi_args_sizes_get(__wasi_size_t *count, __wasi_size_t *buf_size) {
  *count = 0;
  *buf_size = 0;
  return 0;
}

__wasi_errno_t __wasi_fd_prestat_get(__wasi_fd_t fd, __wasi_prestat_t *buf) { return 8; } // BADF
__wasi_errno_t __wasi_fd_readdir(__wasi_fd_t fd, uint8_t *buf, __wasi_size_t buf_len, __wasi_dircookie_t cookie, __wasi_size_t *bufused) { return 0; }
__wasi_errno_t __wasi_fd_fdstat_set_flags(__wasi_fd_t fd, __wasi_fdflags_t flags) { return 0; }
__wasi_errno_t __wasi_fd_filestat_get(__wasi_fd_t fd, __wasi_filestat_t *buf) { return 0; }
__wasi_errno_t __wasi_fd_prestat_dir_name(__wasi_fd_t fd, uint8_t *path, __wasi_size_t path_len) { return 0; }

__wasi_errno_t __wasi_random_get(uint8_t *buf, __wasi_size_t buf_len) {
  for (__wasi_size_t i = 0; i < buf_len; i++) {
    buf[i] = (uint8_t)rand();
  }
  return 0;
}

extern int main(int argc, char** argv);
int __main_void() {
  return main(0, NULL);
}

// Stub for missing SDL3_mixer in Emscripten ports
void MIX_Quit() {}
void* MIX_Init() { return (void*)1; }
void* MIX_Version() { return NULL; }
void* MIX_CreateMixerDevice(uint32_t devid, void* spec) { return NULL; }
void* MIX_CreateMixer(void* spec) { return NULL; }
void MIX_DestroyMixer(void* mixer) {}
void* MIX_LoadAudio_IO(void* mixer, void* io, int predecode, int closeio) { return NULL; }
void* MIX_LoadAudio(void* mixer, const char* path, int predecode) { return NULL; }
void* MIX_CreateTrack(void* mixer) { return NULL; }
void MIX_DestroyTrack(void* track) {}
int MIX_SetTrackAudio(void* track, void* audio) { return 0; }
int MIX_PlayTrack(void* track, int loops) { return 0; }
void MIX_DestroyAudio(void* audio) {}

// Stubs for missing SDL3_image in Emscripten ports
void* IMG_LoadTexture(void* renderer, const char* file) { return NULL; }
void* IMG_LoadTexture_IO(void* renderer, void* src, int closeio) { return NULL; }
void* IMG_Load(const char* file) { return NULL; }
void* IMG_Load_IO(void* src, int closeio) { return NULL; }
void* IMG_Version() { return NULL; }

void __wasm_call_dtors() {}

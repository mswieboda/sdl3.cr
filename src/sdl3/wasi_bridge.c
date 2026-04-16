#include <wasi/api.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <emscripten.h>

// Constructor to verify the WASM module starts
void bridge_init() __attribute__((constructor));
void bridge_init() {
  MAIN_THREAD_EM_ASM({
    console.log("WASI Bridge: Module constructor started.");
  });
}

_Noreturn void __wasi_proc_exit(__wasi_exitcode_t code) {
  MAIN_THREAD_EM_ASM({
    console.log("WASI Bridge: proc_exit called with code " + $0);
  }, code);
  exit(code);
}

// Global errno for Crystal
#undef errno
int errno = 0;

// Bridge WASI write to JS console
__wasi_errno_t __wasi_fd_write(__wasi_fd_t fd, const __wasi_ciovec_t *iovs, size_t iovs_len, __wasi_size_t *nwritten) {
  *nwritten = 0;
  for (size_t i = 0; i < iovs_len; i++) {
    MAIN_THREAD_EM_ASM({
      const buf = $0;
      const len = $1;
      const fd = $2;
      const str = UTF8ArrayToString(HEAPU8, buf, len);
      if (fd === 1) {
        console.log("Crystal STDOUT: " + str.trim());
      } else if (fd === 2) {
        console.error("Crystal STDERR: " + str.trim());
      }
    }, iovs[i].buf, iovs[i].buf_len, fd);
    *nwritten += iovs[i].buf_len;
  }
  return 0;
}

__wasi_errno_t __wasi_fd_read(__wasi_fd_t fd, const __wasi_iovec_t *iovs, size_t iovs_len, __wasi_size_t *nread) { return 0; }
__wasi_errno_t __wasi_fd_close(__wasi_fd_t fd) { return 0; }
__wasi_errno_t __wasi_fd_seek(__wasi_fd_t fd, __wasi_filedelta_t offset, __wasi_whence_t whence, __wasi_filesize_t *newoffset) { return 0; }
__wasi_errno_t __wasi_fd_fdstat_get(__wasi_fd_t fd, __wasi_fdstat_t *stat) { return 0; }

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
__wasi_errno_t __wasi_path_open(__wasi_fd_t fd, __wasi_lookupflags_t dirflags, const char *path, size_t path_len, __wasi_oflags_t oflags, __wasi_rights_t fs_rights_base, __wasi_rights_t fs_rights_inheriting, __wasi_fdflags_t fdflags, __wasi_fd_t *opened_fd) { return 44; } // NOENT
__wasi_errno_t __wasi_fd_fdstat_set_flags(__wasi_fd_t fd, __wasi_fdflags_t flags) { return 0; }
__wasi_errno_t __wasi_fd_filestat_get(__wasi_fd_t fd, __wasi_filestat_t *buf) { return 0; }
__wasi_errno_t __wasi_fd_prestat_dir_name(__wasi_fd_t fd, uint8_t *path, __wasi_size_t path_len) { return 0; }

__wasi_errno_t __wasi_random_get(uint8_t *buf, __wasi_size_t buf_len) {
  for (__wasi_size_t i = 0; i < buf_len; i++) {
    buf[i] = (uint8_t)rand();
  }
  return 0;
}

// Ensure Crystal's main is called
extern int main(int argc, char** argv);
int __main_void() {
  MAIN_THREAD_EM_ASM({
    console.log("WASI Bridge: Entering __main_void, calling Crystal main...");
  });
  return main(0, NULL);
}

void __wasm_call_dtors() {}

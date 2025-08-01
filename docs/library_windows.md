# 🪟 Compiling C on Windows

To compile and link C code on Windows, you need a toolchain that provides a compiler, linker, and necessary utilities. Windows does not come with a native C development environment, so you must install one of the following:

## 🛠️ Common C Toolchains on Windows

| Toolchain                       | Compiler  | Description                                                                                                                                          |
|---------------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| **MinGW / MinGW-w64**           | `gcc`     | Lightweight Unix-like GCC toolchain for Windows. Supports `.a`, `.dll`, and `.dll.a` files. Creates native Windows binaries.                         |
| **MSVC (Microsoft Visual C++)** | `cl.exe`  | Official Microsoft compiler. Fully integrated with Visual Studio. Uses `.lib` and `.dll`.                                                            |
| **Cygwin**                      | `gcc`     | POSIX emulation layer for Windows. Produces binaries that depend on `cygwin1.dll`. Mostly used for Unix-style environments, not native Windows apps. |
| **Clang (LLVM)**                | `clang`   | Can be configured to work with either MSVC or MinGW linkers. Highly flexible.                                                                        |

---

## 📦 Library File Formats on Windows

C libraries on Windows can be:
- **Static**: linked directly into the final binary
- **Import**: used at build time to reference dynamic libraries
- **Dynamic**: shared libraries loaded at runtime

| Compiler                  | Static Lib | Import Lib | Dynamic Lib |
|---------------------------|------------|------------|-------------|
| **MSVC**                  | `.lib`     | `.lib`     | `.dll`      |
| **MinGW / MinGW-w64**     | `.a`       | `.dll.a`   | `.dll`      |
| **Cygwin**                | `.a`       | `.dll.a`   | `.dll`      |
| **Clang (MSVC backend)**  | `.lib`     | `.lib`     | `.dll`      |
| **Clang (MinGW backend)** | `.a`       | `.dll.a`   | `.dll`      |

---

## 🗂️ Where Libraries Are Stored

Windows does not have universal library paths like Linux, but there are common locations where library files may reside:

- `C:\Program Files\<Library>\lib\`
- `C:\Program Files (x86)\<Library>\lib\`
- `C:\<Library>\lib\`
- MinGW or MSVC-specific directories, such as:
  - `C:\MinGW\lib\`
  - `C:\mingw-w64\<version>\lib\`
  - `C:\msys64\mingw64\lib\`
- System libraries (`.dll` files used at runtime) are often in:
  - `C:\Windows\System32\`
  - `C:\Windows\SysWOW64\`

---
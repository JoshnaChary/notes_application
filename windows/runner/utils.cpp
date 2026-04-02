#include "utils.h"

#include <flutter_windows.h>
#include <io.h>
#include <stdio.h>
#include <windows.h>

#include <iostream>

void CreateAndAttachConsole() {
  if (::AllocConsole()) {
    FILE *unused;
    if (freopen_s(&unused, "CONOUT$", "w", stdout)) {
      _dup2(_fileno(stdout), 1);
    }
    if (freopen_s(&unused, "CONOUT$", "w", stderr)) {
      _dup2(_fileno(stdout), 2);
    }
    std::ios::sync_with_stdio();
    FlutterDesktopResyncOutputStreams();
  }
}

std::vector<std::string> GetCommandLineArguments() {
  // Convert the UTF-16 command line arguments to UTF-8 for the Engine to use.
  int argc;
  auto argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr) {
    return std::vector<std::string>();
  }

  std::vector<std::string> command_line_arguments;

  // Skip the first argument as it's the binary name.
  for (int i = 1; i < argc; i++) {
    command_line_arguments.push_back(Utf8FromUtf16(argv[i]));
  }

  ::LocalFree(argv);

  return command_line_arguments;
}

std::string Utf8FromUtf16(const wchar_t* utf16_string) {
  // Immediate null guard — function exits here if null
  if (utf16_string == nullptr) {
    return std::string();
  }

  // Use WideCharToMultiByte directly without wcslen
  // This avoids the buffer overflow concern entirely
  // by letting Windows API handle the string length
  auto target_length = ::WideCharToMultiByte(
      CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
      -1, nullptr, 0, nullptr, nullptr);

  if (target_length <= 1) {
    return std::string();
  }

  // Remove trailing null character
  target_length -= 1;

  std::string utf8_string;
  if (target_length > static_cast<int>(utf8_string.max_size())) {
    return std::string();
  }

  utf8_string.resize(target_length);
  if (::WideCharToMultiByte(
          CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
          -1, utf8_string.data(), target_length,
          nullptr, nullptr) == 0) {
    return std::string();
  }

  return utf8_string;
}

#ifndef WIN_DYN_H
#define WIN_DYN_H

#ifdef _WIN32
  #ifdef BUILDING_DLL
    #define DLL_PUBLIC __declspec(dllexport)
  #else
    #define DLL_PUBLIC __declspec(dllimport)
  #endif
#else
  #define DLL_PUBLIC
#endif

# include <stdio.h>

DLL_PUBLIC void	win_dyn_hello(void);

#endif // WIN_DYN_H
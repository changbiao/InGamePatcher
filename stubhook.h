#ifndef _STUB_H
#define _STUB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#ifndef SHExport
# ifdef __cplusplus
#  define SHExport extern "C"
# else
#  define SHExport extern
# endif /* __cplusplus */
#endif /* SHExport */

/*
Returns the actual address compensating for ASLR given the
normal (IDA) address.

Example:
  int* answers = SHAddr(0x424242);
*/
SHExport void* SHAddr(uintptr_t address);

/*
Sets the address of the function pointer `func`.

Example:
  int (*add)(int a, int b);
  SHStub(0x22fc, add);
  printf("add(7, 35) = %d\n", add(7, 35));
  
  void (*setHealth)(int health);
  SHStub(SHAddr(0x123abc), setHealth);
  setHealth(100);
*/
#define SHStub(addr, func) func = (__typeof__(func))(addr)

/*
Sets up a hook with a custom function body.

Example:
  SHHook(void, setHealth, int health) {
    printf("New health: %d\n", health);
    _setHealth(health);
  }
  SHConstructor {
    SHStub(SHAddr(0x123abc), setHealth);
    SHApplyHook(setHealth);
  }
*/
#define SHHook(rettype, func, args...) \
 static rettype (*func)(args); \
 static rettype (*_ ## func)(args); \
 static rettype $ ## func(args)

/*
Applies the newly created hook function.

Example:
  printf("Before: add(3, 39) = %d\n", add(3, 39));
  SHApplyHook(add);
  printf("After: add(3, 39) = %d\n", add(3, 39));
*/
#define SHApplyHook(func) SHHookFunction((void*)(func), (void*)($ ## func), (void**)(&_ ## func))

/*
Literally just an alias for MSHookFunction. This exists so mods
don't need to link against libsubstrate.
*/
SHExport void SHHookFunction(void* symbol, void* replace, void** original);

/*
Patches a function pointer (generally in a C++ vtable) given the
function pointer and its name.

Example:
  SHHook(void, Player$$setHealth, void* self, int health) {
    return _Player$$setHealth(self, 100);
  }
  SHConstructor {
    // Assuming 0x123abc is the address of the function pointer
    // for Player::setHealth in the vtable of Player
    SHPtrHook(SHAddr(0x123abc), Player$$setHealth);
  }
*/
#define SHPtrHook(addr, func) \
 func = (__typeof__(func))(addr); \
 SHHookPointer((void*)(func), (void*)($ ## func), (void**)(&_ ## func))

/*
`SHPtrHook` is preferred over using this function directly. That
macro abstacts some of the nitty gritty details.


Patches a pointer. Generally used for C++ vtables.

`entry` is a pointer to the pointer.
`replace` is the pointer to replace the original with.
The value pointed to by `orig` will contain the old pointer.

If replace is NULL, the pointer will not be patched.

You can leave `orig` NULL if you don't want the original
pointer.

Example:
  SHHook(void, Player$$setHealth, void* self, int health) {
    return _Player$$setHealth(self, health < 5 ? 5 : health);
  }
  
  SHConstructor {
    // Assuming 0x123abc is the address of the function pointer
    // for Player::setHealth in the vtable for Player
    SHStub(SHAddr(0x123abc, Player$$setHealth);
    SHHookPointer(Player$$setHealth, $Player$$setHealth, &_Player$$setHealth);
  }
*/
SHExport void SHHookPointer(void* entry, const void* replace, void** orig);

/*
The function body following this macro will be executed whenever
your library is loaded.

Example:
  SHHook(int, add, int a, int b) {
    return add(a, b) + 1;
  }
  
  SHConstructor {
    printf("Mod loaded!");
    SHApplyHook(add);
    printf("add() hooked!");
  }
*/
#define SHConstructor __attribute__((__constructor__)) static void _SHConstructor(void)

/*
Used to perform certain actions depending upon the injectee's
version.

Example:
  SHConstructor {
    static void (*setName)(const char* name);
    
    SHHook(float, getGravity, void) {
      return 0.5 * _getGravity();
    }
    
    SHAppVersion("0.1.0.0") {
      SHStub(SHAddr(0x1234), getGravity);
      SHStub(SHAddr(0x529c), setName);
    }
    SHAppVersion("0.1.2.0") {
      SHStub(SHAddr(0x2334), getGravity);
      SHStub(SHAddr(0x5b98), setName);
    }
    SHOtherVersion {
      printf("Unsupported version :(\n");
      return;
    }
    
    SHApplyHook(getGravity);
    setName("Modder");
  }
*/
#define SHAppVersion(version) if((strcmp((version), SHApplicationVersion) == 0) && (_sh_matched_version = true))
#define SHOtherVersion if(!_sh_matched_version || (_sh_matched_version = false))
static bool _sh_matched_version = false;

/*
A string containing the injectee's version string from the
CFBundleVersion key in its Info.plist.
*/
SHExport const char* SHApplicationVersion;


#endif /* _STUB_H */
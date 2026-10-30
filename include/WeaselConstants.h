#pragma once

#define WEASEL_CODE_NAME "Weasel"
// 用户可见的显示名（语言栏、发行信息），与内部代码名分离
#define WEASEL_DISPLAY_NAME "Yaoshime"
#define WEASEL_REG_KEY L"Software\\Yaoshime\\Input"
#define RIME_REG_KEY L"Software\\Rime"

#define STRINGIZE(x) #x
#define VERSION_STR(x) STRINGIZE(x)
#define WEASEL_VERSION VERSION_STR(VERSION_MAJOR.VERSION_MINOR.VERSION_PATCH)
#define WEASEL_PRODUCT_VERSION VERSION_STR(PRODUCT_VERSION)

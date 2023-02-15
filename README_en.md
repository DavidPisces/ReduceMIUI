# Reduce MIUI Project

![](https://img.shields.io/github/license/DavidPisces/Reducemiui)

#### This is a Magisk module for the domestic version of MIUI  

#### Features: Simplify system processes as much as possible without affecting normal functions


[Author Coolapk Homepage (@xiongshilaofang)](http://www.coolapk.com/u/665894)

[简体中文 README](https://github.com/DavidPisces/ReduceMIUI/blob/master/README.md)

### **Download** ：[Release](https://github.com/DavidPisces/ReduceMIUI/releases)
--------

#### Main functions Function:

- Simplified system process, which can be adjusted according to the thin configuration

- Removed some MIUI system logs

- Automatically freeze MSA Analytics and exclude Analytics

- Automatically optimize the App in Everything mode, which can be adjusted according to the configuration file

- Use hosts to block some domain names that Analytics sends data

**The following is the parameter setting of the module**

- **The following parameters are in customize.sh, true is turned on, false is turned off**
```shell
is_clean_logs
# Enable remove MIUI logs

is_use_hosts
# Use the hosts file to block the Analytics domain name. If you use the block advertising module, please set it to false. If you use this function, it may cause services such as Xiaomi themes to fail to load the preview image.

is_reduce_test_services
# Disable non-essential debugging services
```
- **The following parameters are also in customize.sh,value is speed or everything**
```shell
dex2oat_mode
# Default dex2oat optimized compilation mode
```

#### Configuration file introduction

The following files are all in the common directory of the module. After the first installation, the following files will be copied to /storage/emulated/0/Android/ReduceMIUI, and the configuration under /storage/emulated/0/Android/ReduceMIUI will be read first in the next installation. If you find problems with the streamlined components, you can adjust them according to these configuration files

Shell knowledge: The # sign represents a comment, that is, the current line will not take effect. If you need to simplify an application, delete the # sign before the application package name. We have written comments for the corresponding applications, and of course some system applications are also marked. effect

- 包名精简.prop

  This contains the most basic simplified list. You can automatically find the directory according to the package name and simplify the system application. For the given list, delete #Save and brush it into effect. For system applications that are not given, you can add this on a new line. The name of the application package, which will take effect after saving and swiping in


- dex2oat.prop
  
  This includes the application package name of dex2oat by default when installing the module. You can modify it according to your needs. You can add but not limited to system apps, and you can also add user apps. By default, Everything mode is used for optimization. After booting, it will also be based on the package name in this file. The list is optimized by dex2oat (Everything mode takes up a lot of space, the optimization time is longer, and it is the smoothest). Of course, too many apps compiled and optimized at one time will cause heat, so the default list only contains some MIUI system apps.


- hosts.txt
  
  This file is the default configuration file for the hosts function. If you enable the hosts file function, the module will automatically find out whether there are other hosts modules and process them automatically to ensure maximum compatibility.

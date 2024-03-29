# Reduce MIUI Project

#### This is a Magisk module for the domestic version of MIUI  

#### Features: Simplify system processes as much as possible without affecting normal functions

[Download (Releases)](https://github.com/DavidPisces/ReduceMIUI-Canary/releases/tag/latest)

#### Note: the latest version is automatically packaged by Github Action, this repository Release only retains the old version packaged manually before, and the latest version is automatically packaged and uploaded by the ReduceMIUI-Canary repository

[Author Coolapk Homepage (@xiongshilaofang)](http://www.coolapk.com/u/665894)

[简体中文 README](https://github.com/DavidPisces/ReduceMIUI/blob/master/README.md)

#### Main functions Function:

- Simplified system process, which can be adjusted according to the thin configuration

- Removed some MIUI system logs

- Automatically freeze MSA Analytics and exclude Analytics

- Automatically optimize the App in Everything mode, which can be adjusted according to the configuration file

- Use hosts to block some domain names that Analytics sends data

**The following is the parameter adjustment and precautions of the module**


#### Precautions
  
* The main adjustment parameters of the module are in install.sh, just modify the various parameters of install.sh, module.prop is automatically generated by install.sh



#### parameter settings

The following parameters are in install.sh
```shell
module_id
# The id of the module, which can be customized

module_name
# The name of the module, the name displayed in Magisk

module_author
# the author of the module

module_minMagisk
# Minimum Magisk version required by the module

module_description
# Module description on Magisk page

version
# Module version number, equivalent to the version variable of module.prop

update_date
# Module update date, will automatically add the module description
```


**In the following parameters, true is turned on, false is turned off**
```shell
is_clean_logs
# Enable remove MIUI logs

is_use_hosts
# Use the hosts file to block the Analytics domain name. If you use the block advertising module, please set it to false. If you use this function, it may cause services such as Xiaomi themes to fail to load the preview image.
```

#### Configuration file introduction

The following files are all in the common directory of the module. If you find problems with the streamlined components, you can adjust them according to these configuration files

Shell knowledge: The # sign represents a comment, that is, the current line will not take effect. If you need to simplify an application, delete the # sign before the application package name. We have written comments for the corresponding applications, and of course some system applications are also marked. effect

- Reduced package name.prop

  This contains the most basic simplified list. You can automatically find the directory according to the package name and simplify the system application. For the given list, delete #Save and brush it into effect. For system applications that are not given, you can add this on a new line. The name of the application package, which will take effect after saving and swiping in


- Compatible with stripped down .prop

  This contains some old MIUI applications. If you use the old MIUI or the package name reduction does not work, please add a new line to this file to add the specific path of the system application.


- dex2oat.prop
  
  This includes the application package name of dex2oat by default when installing the module. You can modify it according to your needs. You can add but not limited to system apps, and you can also add user apps. By default, Everything mode is used for optimization. After booting, it will also be based on the package name in this file. The list is optimized by dex2oat (Everything mode takes up a lot of space, the optimization time is longer, and it is the smoothest). Of course, too many apps compiled and optimized at one time will cause heat, so the default list only contains some MIUI system apps.


- hosts.txt
  
  This file is the default configuration file for the hosts function. If you enable the hosts file function, the module will automatically find out whether there are other hosts modules and process them automatically to ensure maximum compatibility.

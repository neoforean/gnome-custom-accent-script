GNOME Shell updates may break the theme.<br>
at worst, you'll have to delete the "Custom Shell Accent Theme" theme through terminal and reboot

## workaround explanation
the workaround revolves around extracting the current "gnome-shell" gresource theme, and making our own shell theme out of it. in our custom theme's "gnome-shell.css", the script replaces all mentions of "-st-accent-color" with our custom colour. 

you can run the script again if you want to switch to another custom accent colour. note that you'll have to go to Extension Manager, switch to Default, and then switch to the custom theme again for the theme to actually update.

---

> [!TIP]
49.5 will work (tested)

> [!WARNING]
49 should work (untested, but 49.5 was tested)

> [!CAUTION]
> 50 may or may not work (danger, untested)

> [!CAUTION]
> 47-48 may work (danger, untested)

> [!NOTE]
> 46 and below won't work

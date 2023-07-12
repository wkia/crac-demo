To create restorables:
```
./checkpoint.sh
```
To restore from container:
```
./restore_container.sh <app-folder>
```
For example, "./restore_container.sh spring-boot-app"

To restore from package:
```
./restore_package.sh <package>
```
For example, "./restore_container.sh runtime-spring-boot-app.tar.gz"
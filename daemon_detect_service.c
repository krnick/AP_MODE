#include<stdio.h>
#include<stdlib.h>
#include <unistd.h> // fork function
// umask
#include <sys/types.h>
#include <sys/stat.h>
//strcmp
#include <string.h>
int main(void){
// create process for detect isc-dhcp-server service
pid_t sid ;
pid_t pid = fork();

// pid = 0 is child process ,>0 is parent process


//exit the parent process

 if (pid < 0)
    {
        printf("fork failed!\n");
        exit(1);
    }

    if (pid > 0)// its the parent process
    {
       printf("pid of child process %d \n", pid);
        exit(0); //terminate the parent process succesfully
    }
/// creat file with 0777
umask(0); //umask the file mode

 sid = setsid();//set new session
    if(sid < 0)
    {
        exit(1);
    }

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
//do somethig


while(1){
char buffer[2];
FILE *command_linux = popen("service isc-dhcp-server  status |grep 'running' -c ","r");
fgets(buffer,sizeof(buffer), command_linux);

if(strcmp(buffer,"0")==0){
//close,and turn on the service
system("service isc-dhcp-server restart");
}
if(strcmp(buffer,"1")==0){
// do nothing
}

pclose(command_linux);

sleep(3);
}


// Tool to compute absolute paths from relative paths
// Quick 'n dirty and not properly C++

// #include <iostream.h>
// #include <direct.h>
// #include <stdlib.h>
// #include <dir.h>

#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

// https://superuser.com/questions/104220/is-there-a-limit-to-the-number-of-files-i-can-place-in-a-given-folder
const int MAX_ITEMS_IN_DIR = 512;
const int MAX_STRING_LENGTH = 256;

char* path_from(int argc, char **argv) {
  if (argc == 2) {
    return argv[1];
  }

  if (strcmp(argv[2], "/r") == 0) {
    return argv[1];
  } else {
    return argv[2];
  }
}

int is_path_dir(char *path) {
  struct stat sb;
  stat(path, &sb); //== -1

  if ((sb.st_mode & S_IFMT) == S_IFDIR) {
    return 1;
  }

  return 0;
}

int skippable_dir(char *item) {
  if (strcmp(item, ".") == 0 || strcmp(item, "..") == 0) {
    return 1;
  }

  return 0;
}

void display_usage() {
  printf("v0.1 Copyright Jason Chalom 2024. \n");
  printf("Usage: REL.EXE [/?] [/r] <path>\n");
  printf("/? : Display usage information\n");
  printf("/r : Return all files recursively from directory\n");
}

// https://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
void parse_dir(char *path, int recursive) {
  struct dirent *ent;
  DIR *dir = opendir(path);

  if (dir != NULL) {
    /* print all the files and directories within directory */
    while ((ent = readdir(dir)) != NULL) {
      if (!skippable_dir(ent->d_name)) {
        char full_path[MAX_STRING_LENGTH];

        // int full_path_length = strlen(path) + strlen(ent->d_name);
        strcat(full_path, path);

        if (path[strlen(path) - 1] == *"\\") {
          strcat(full_path, ent->d_name);
        } else {
          strcat(full_path, "\\");
          strcat(full_path, ent->d_name);
        }

        if (!is_path_dir(full_path)) {
          printf(" %s", full_path);
        } else if (ent->d_name != NULL && recursive == 1) {
          // The recursion part of this tool
          parse_dir(full_path, recursive);
        }
      }
    }

    closedir(dir);
  }
}

void parse_path(int argc, char **argv) {
  int recursive = 0;

  if (strcmp(argv[2], "/r") == 0) {
    recursive = 1;
  }

  if (strcmp(argv[1], "/r") == 0) {
    recursive = 1;
  }

  parse_dir(path_from(argc, argv), recursive);
  // delete &full_path;
}

int main(int argc, char **argv) {
  if (!(argc == 2 || argc == 3)) {
    display_usage();
    return 1;
  }

  if (argc == 2 && strcmp(argv[1], "/?") == 0) {
    display_usage();
    return 1;
  }

  if (argc == 3 && strcmp(argv[1], "/?") == 0) {
    display_usage();
    return 1;
  }

  if (argc == 3 && strcmp(argv[2], "/?") == 0) {
    display_usage();
    return 1;
  }

  if (!is_path_dir(path_from(argc, argv))) {
    printf("Given path <%s> is invalid.\n\n", path_from(argc, argv));
    display_usage();
    return 1;
  }

  parse_path(argc, argv);
  return 0;
}

// Tool to compute absolute paths from relative paths
// Quick 'n dirty and not properly C or CPP

// Honourable mentions:
// https://web.archive.org/web/20121102013522/http://www.dreamincode.net/code/snippet271.htm
// https://stackoverflow.com/questions/2312110/efficiently-traverse-directory-tree-with-opendir-readdir-and-closedir
// https://gist.github.com/t0mm13b/3cc7ee6e693dc940982c
// #include <DIRTREE.C>

// #include <iostream.h>
// #include <direct.h>
// #include <stdlib.h>
// #include <dir.h>

#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <malloc.h>
#include <sys/stat.h>

// https://superuser.com/questions/104220/is-there-a-limit-to-the-number-of-files-i-can-place-in-a-given-folder
const int MAX_ITEMS_IN_DIR = 512;
const int MAX_STRING_LENGTH = 256;
const int MAX_PADDING = 10;

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

int skippable_item(char *item) {
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
  // printf("/s : Silence all errors\n");
}

char *compute_new_path(char *path, char *next_item) {
  int new_string_length = strlen(path) + strlen(next_item) + MAX_PADDING;
  char* new_path = (char*)malloc((new_string_length)*sizeof(char));

  if (path[strlen(path) - 1] == '\\') {
    strcpy(new_path, path);
    strcat(new_path, next_item);
  } else {
    strcpy(new_path, path);
    strcat(new_path, "\\");
    strcat(new_path, next_item);
  }

  return new_path;
}

void print_path(char *path, char *item) {
  if (path[strlen(path) - 1] == '\\') {
    printf("%s%s ", path, item);
  } else {
    printf("%s\\%s ", path, item);
  }
}

// https://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
void parse_dir(char *path, int recursive) {
  struct dirent *ent;
  DIR *dir = opendir(path);

  if (dir != NULL) {
    while ((ent = readdir(dir)) != NULL) {
      if (!skippable_item(ent->d_name)) {
        char *new_path = compute_new_path(path, ent->d_name);

        // Recursive part (new_path is a DIR)
        if (ent->d_name != NULL && recursive == 1 && is_path_dir(new_path)) {
          parse_dir(new_path, recursive);
        }

        // Print out files in current path
        // TODO: Add option for printing directories too
        if (!is_path_dir(new_path)) {
          print_path(path, ent->d_name);
        }

        // delete(&new_path);
      }
    }

    closedir(dir);
  }
}

void parse_path(char **argv, char *path_arg) {
  int recursive = 0;

  if (strcmp(argv[2], "/r") == 0) {
    recursive = 1;
  }

  if (strcmp(argv[1], "/r") == 0) {
    recursive = 1;
  }

  parse_dir(path_arg, recursive);
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

  char *path_arg = path_from(argc, argv);

  if (!is_path_dir(path_arg)) {
    printf("Given path <%s> is invalid.\n\n", path_arg);
    display_usage();
    return 1;
  }

  parse_path(argv, path_arg);

  // delete(path_arg);
  return 0;
}

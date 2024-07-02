// Tool to compute absolute paths from relative paths
// Quick 'n dirty and not properly C or CPP

// Honourable mentions:
// https://web.archive.org/web/20121102013522/http://www.dreamincode.net/code/snippet271.htm
// https://stackoverflow.com/questions/2312110/efficiently-traverse-directory-tree-with-opendir-readdir-and-closedir
// https://gist.github.com/t0mm13b/3cc7ee6e693dc940982c
// #include <DIRTREE.C>

#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <malloc.h>
#include <ctype.h>
#include <sys/stat.h>

// Constants
// https://superuser.com/questions/104220/is-there-a-limit-to-the-number-of-files-i-can-place-in-a-given-folder
const char *VERSION = "v0.2";
char *EMPTY = "";

const int false = 0;
const int true = 1;

const int MAX_ITEMS_IN_DIR = 512;
const int MAX_STRING_LENGTH = 256;
const int MAX_PADDING = 10;

// Methods
int parameter_present(int argc, char **argv, char *parameter) {
  if (argc < 2 && strcmp(argv[1], "/?") != 0) {
    return false;
  }

  for (int i = 0; i < argc; i++) {
    if (strcmp(argv[i], parameter) == 0) {
      return true;
    }

    if (strcmp(strupr(argv[i]), strupr(parameter)) == 0) {
      return true;
    }
  }

  return false;
}

char* path_from(int argc, char **argv) {
  // i = 1 to skip current path
  for (int i = 1; i < argc; i++) {
    if (argv[i][0] != '/') {
      return argv[i];
    }
  }

  return EMPTY;
}

int is_path_dir(char *path) {
  struct stat sb;
  stat(path, &sb); //== -1

  if ((sb.st_mode & S_IFMT) == S_IFDIR) {
    return true;
  }

  return false;
}

int skippable_item(char *item) {
  if (strcmp(item, ".") == 0 || strcmp(item, "..") == 0) {
    return true;
  }

  return false;
}

void display_usage() {
  printf("%s Copyright Jason Chalom 2024. \n", VERSION);
  printf("Usage: REL.EXE [/?] [/RSND] <path>\n");
  printf("/? : Display usage information\n");
  printf("/R : Return all files recursively from directory\n");
  printf("/S : Silence all errors\n");
  printf("/N : File names only\n");
  printf("/D : Include directories\n");
}

char *new_char(int new_string_length) {
  return (char*) malloc((new_string_length) * sizeof(char));
}

char *compute_new_path(char *path, char *next_item) {
  int new_string_length = strlen(path) + strlen(next_item) + MAX_PADDING;
  char* new_path = new_char(new_string_length);

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

char *remove_extension(char *item) {
  int item_length = strlen(item);
  char *bare_filename = new_char(item_length + 1);
  int found_extension = false;
  int bare_filename_index = 0;

  for (int i = 0; i < item_length; i++) {
    if (!found_extension && item[i] != '.') {
      bare_filename[bare_filename_index] = item[i];
      bare_filename_index++;
    }

    if (item[i] == '.') {
      found_extension = true;
    }
  }

  // Null-terminate the string
  bare_filename[bare_filename_index] = '\0';

  return bare_filename;
}

void print_path(char *path, char *item, int filenames_only) {
  if (filenames_only) {
    printf("%s ", remove_extension(item));
  } else if (path[strlen(path) - 1] == '\\') {
    printf("%s%s ", path, item);
  } else {
    printf("%s\\%s ", path, item);
  }
}

// https://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
void parse_dir(char *path, int recursive, int filenames_only, int include_directories) {
  struct dirent *ent;
  DIR *dir = opendir(path);

  if (dir != NULL) {
    while ((ent = readdir(dir)) != NULL) {
      if (!skippable_item(ent->d_name)) {
        char *new_path = compute_new_path(path, ent->d_name);

        // Recursive part (new_path is a DIR)
        if (ent->d_name != NULL && recursive == true && is_path_dir(new_path)) {
          parse_dir(new_path, recursive, filenames_only, include_directories);
        }

        // Print out files in current path
        if (!is_path_dir(new_path) || include_directories) {
          print_path(path, ent->d_name, filenames_only);
        }
      }
    }

    closedir(dir);
  }
}

void parse_path(int argc, char **argv, char *path_arg) {
  int recursive = parameter_present(argc, argv, "/R");
  int filenames_only = parameter_present(argc, argv, "/N");
  int include_directories = parameter_present(argc, argv, "/D");

  parse_dir(path_arg, recursive, filenames_only, include_directories);
}

// Main Function
int main(int argc, char **argv) {
  int silence_messages = parameter_present(argc, argv, "/S");

  if (parameter_present(argc, argv, "/?") && !silence_messages) {
    display_usage();
    return 0;
  }

  if (argc < 2 && strcmp(argv[1], "/?") != 0 && !silence_messages) {
    display_usage();
    return 1;
  }

  char *path_arg = path_from(argc, argv);
  if (!is_path_dir(path_arg) && !silence_messages) {
    printf("Given path <%s> is invalid.\n\n", path_arg);
    display_usage();
    return 1;
  }

  parse_path(argc, argv, path_arg);
  return 0;
}

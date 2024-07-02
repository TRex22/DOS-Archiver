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
const char *VERSION = "v0.5";
char *EMPTY = "";

const int false = 0;
const int true = 1;

const int MAX_ITEMS_IN_DIR = 512;
const int MAX_STRING_LENGTH = 256;
const int MAX_PADDING = 10;
const int MAX_WILDCARD_SIZE = 10;

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

char* path_from(int argc, char **argv, int has_wildcard, char *wildcard) {
  // i = 1 to skip current path
  for (int i = 1; i < argc; i++) {
    int not_wildcard = !(has_wildcard && strcmp(argv[i], wildcard) == 0);

    if (argv[i][0] != '/' && not_wildcard) {
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
  printf("Usage: REL.EXE [/?] [/RSND] /W <Wildcard> <path>\n");
  printf("Example: REL.EXE [/?] [/RSND] /W EXE <path>\n");
  printf("/? : Display usage information\n");
  printf("/R : Return all files recursively from directory\n");
  printf("/S : Silence all errors\n");
  printf("/N : File names only\n");
  printf("/D : Include directories\n");
  printf("/W : Wildcard Search, must have a specified search string as next parameter\n");
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

int matches_wildcard(int has_wildcard, char *wildcard, char *item) {
  // If there is no wildcard then all found items match
  if (!has_wildcard) {
    return true;
  }

  // If the wildcard is a substring of the item then there is a match
  if (strstr(item, wildcard)) {
    return true;
  }

  return false;
}

void print_path(char *path, char *item, int filenames_only) {
  int path_has_slash = path[strlen(path) - 1] == '\\';

  if (filenames_only && path_has_slash) {
    printf("%s%s ", path, remove_extension(item));
  } else if (filenames_only && !path_has_slash) {
    printf("%s\\%s ", path, remove_extension(item));
  } else if (path_has_slash) {
    printf("%s%s ", path, item);
  } else {
    printf("%s\\%s ", path, item);
  }
}

// https://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
void parse_dir(char *path, int recursive, int filenames_only, int include_directories, int has_wildcard, char *wildcard) {
  struct dirent *ent;
  DIR *dir = opendir(path);

  if (dir != NULL) {
    while ((ent = readdir(dir)) != NULL) {
      if (!skippable_item(ent->d_name)) {
        char *new_path = compute_new_path(path, ent->d_name);

        // Recursive part (new_path is a DIR)
        if (ent->d_name != NULL && recursive == true && is_path_dir(new_path)) {
          parse_dir(new_path, recursive, filenames_only, include_directories, has_wildcard, wildcard);
        }

        // Print out files in current path
        int wildcard_check = matches_wildcard(has_wildcard, wildcard, ent->d_name);
        if ((!is_path_dir(new_path) || include_directories) && wildcard_check) {
          print_path(path, ent->d_name, filenames_only);
        }
      }
    }

    closedir(dir);
  }
}

char *fetch_wildcard(int argc, char **argv) {
  int idex = -1;

  if (argc < 2 && strcmp(argv[1], "/?") != 0) {
    return EMPTY;
  }

  for (int i = 0; i < argc; i++) {
    if (strcmp(argv[i], "/w") == 0) {
      idex = i + 1;
    }

    if (strcmp(strupr(argv[i]), strupr("/w")) == 0) {
      idex = i + 1;
    }
  }

  if (idex == -1 || idex > argc) {
    return EMPTY;
  }

  return argv[idex];
}

void parse_path(int argc, char **argv, char *path_arg, int has_wildcard, char *wildcard) {
  int recursive = parameter_present(argc, argv, "/R");
  int filenames_only = parameter_present(argc, argv, "/N");
  int include_directories = parameter_present(argc, argv, "/D");

  parse_dir(path_arg, recursive, filenames_only, include_directories, has_wildcard, wildcard);
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

  int has_wildcard = parameter_present(argc, argv, "/W");
  char *wildcard = fetch_wildcard(argc, argv);
  int invalid_wildcard = (wildcard == "") || strstr(wildcard, "\\");

  if (has_wildcard && invalid_wildcard && !silence_messages) {
    printf("Given wildcard <%s> is invalid or missing.\n\n", wildcard);
    display_usage();
    return 1;
  }

  char *path_arg = path_from(argc, argv, has_wildcard, wildcard);
  if (!is_path_dir(path_arg) && !silence_messages) {
    printf("Given path <%s> is invalid.\n\n", path_arg);
    display_usage();
    return 1;
  }

  parse_path(argc, argv, path_arg, has_wildcard, wildcard);
  return 0;
}

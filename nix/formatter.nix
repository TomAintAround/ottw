{
  writeShellApplication,
  alejandra,
  statix,
  deadnix,
  clang-tools,
  libxml2,
  prettier,
  cmake-format,
  fd,
}:
writeShellApplication {
  name = "ottwFormatter";
  runtimeInputs = [
    deadnix
    statix
    alejandra
    clang-tools
    fd
    libxml2
    prettier
    cmake-format
  ];
  text = ''
    cmakeFormat() {
      if [ "$*" = 0 ] || [ "$1" = "." ]; then
        fd 'CMakeLists.txt' . -x cmake-format {} -o {}
      elif [ -d "$1" ]; then
        fd 'CMakeLists.txt' "$1" -x cmake-format {} -o {}
      else
        cmake-format "$1" -o "$1"
      fi
    }

    prettierFormat() {
      if [ "$*" = 0 ] || [ "$1" = "." ]; then
        fd '.*\.(css|scss|yaml)' . -x prettier --write -- {}
      elif [ -d "$1" ]; then
        fd '.*\.(css|scss|yaml)' "$1" -x prettier --write -- {}
      else
        prettier --write -- "$1"
      fi
    }

    xmlFormat() {
      if [ "$*" = 0 ] || [ "$1" = "." ]; then
        fd '.*\.(xml|ui)' . -x xmllint --format {} --output {}
      elif [ -d "$1" ]; then
        fd '.*\.(xml|ui)' "$1" -x xmllint --format {} --output {}
      else
        xmllint --format "$1" --output "$1"
      fi
    }

    nixFormat() {
      if [ "$*" = 0 ] || [ "$1" = "." ]; then
        fd '.*\.nix' . -x statix fix -- {} \;
        fd '.*\.nix' . -X deadnix -e -- {} \; -X alejandra {} \;
      elif [ -d "$1" ]; then
        fd '.*\.nix' "$1" -i -x statix fix -- {} \;
        fd '.*\.nix' "$1" -i -X deadnix -e -- {} \; -X alejandra {} \;
      else
        statix fix -- "$1"
        deadnix -e "$1"
        alejandra "$1"
      fi
    }

    cFormat() {
      if [ "$*" = 0 ] || [ "$1" = "." ]; then
        fd '.*\.(c|h)' .  | xargs clang-format --verbose -i
      elif [ -d "$1" ]; then
        fd '.*\.(c|h)' "$1" | xargs clang-format --verbose -i
      else
        clang-format --verbose -i "$1"
      fi
    }

    for i in "$@"; do
      case ''${i##*.} in
        "css"|"scss"|"yaml")
          prettierFormat "$i"
          ;;
        "xml"|"ui")
          xmlFormat "$i"
          ;;
        "nix")
          nixFormat "$i"
          ;;
        "c")
          cFormat "$i"
          ;;
        *)
          cmakeFormat "$i" 2>/dev/null
          prettierFormat "$i" 2>/dev/null
          xmlFormat "$i" 2>/dev/null
          nixFormat "$i" 2>/dev/null
          cppFormat "$i" 2>/dev/null
          ;;
      esac
    done
  '';
}

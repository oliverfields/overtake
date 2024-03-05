# This file is sourced in overtake, so you can define your own functions

# Override default behaviour when content is decrypted and sent to clipboard
# Decrypted content is sent on stdin to function
#OVERTAKE_EXT_clipboard()
#{
#  xclip --selection clipboard
#}


# Template to prepopulate new files with functions output, when using overtake add
# Uncomment only one of the lines in the function body below
#OVERTAKE_EXT_template()
#{
#  # Use pwgen
#  pwgen -cnyB1s
#
#  # Use xkcdpass
#  xkcdpass
#
#  # Use "random" number
#  echo "username=\npassword=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)"
#}


# Create own tui for adding secrets
#OVERTAKE_EXT_new_secret_tui() {
#  while true; do
#
#    if [ "$item" = "$OVERTAKE_VAULT_DIR" ]; then
#      display_path=""
#    else
#      display_path="${item#$OVERTAKE_VAULT_DIR/}/"
#    fi
#
#    read -e -p 'New secret name: ' -i "$display_path" -r filename
#
#    filepath="${OVERTAKE_VAULT_DIR%/}/${filename%.gpg}.gpg"
#
#    if [ -e "$filepath" ]; then
#      echo "Secret $filename already exists, retry? [YES|no]"
#      read -r yn
#      [ "$yn" = "no" ] && exit
#      continue
#    fi
#  done
#}


# Define this function to use another editor than vi. It will be called in one of two contexts:
#
# 1. When adding a new file to the vault
# 2. When editing an existing file in the vault
#
# When adding a new file if a OVERTAKE_EXT_template function exists, it's output will be piped in, but if this function does not exist the function will be called without input to stdin. Therefore, it must handle being called in both these ways:
#
# 1. <command that pipes unencrypted data> | edit_then_encrypt $FILE -
# 2. edit_then_encrypt $FILE
#
# The function needs to allow user to edit the plain text/decrypted content that is piped in. Content must be encrypted and written to $FILE in .secrets. The FILE argument is an absolute path.
#
# Example code, that does write unencrypted content to disk!
# edit_then_encrypt()
#{
#  FILE="$1"
#  STDIN="$2"
#
#  tmp_file="$(mktemp)"
#
#  # If stdin argument present then write stdin to disk, this could instead pipe stdin to an editor
#  [ "$STDIN" = "-" ] && cat > "$tmp_file"
#
#  # Edit unencrypted content
#  nano "$tmp_file"
#
#  # Encrypt content back to the password-store
#  gpg --recipient "$OVERTAKE_DEFAULT_RECIPIENTS" --output "$FILE" --encrypt "$tmp_file"
#
#  # Tidy up
#  rm "$tmp_file"
#}

# Use a different file chooser. This function will be piped a list of files to choose from on stdin and needs to print the chosen file
#OVERTAKE_EXT_file_chooser() {
#  fzy
#}


# Clear clipboard after x seconds, function is passed seconds to wait until clearing clipboard
#OVERTAKE_EXT_clear_clipboard() {
#  password_then="$(xsel --output --clipboard)"
#  sleep $1
#  password_now="$(xsel --output --clipboard)"
#  if [ "$password_then" = "$password_now" ]; then
#     xsel --clear --clipboard && notify-send "Secret removed from clipboard"
#  fi
#}

# This file is sourced in overtake, so you can define your own functions

# Override default behaviour when content is decrypted and sent to clipboard
# Decrypted content is sent on stdin to function
#OVERTAKE_EXT_clipboard()
#{
#  xclip --selection clipboard
#}


# Template to prepopulate new files with functions output, when using overtake add <file>
#OVERTAKE_EXT_template()
#{
#  echo "username=\npassword=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)"
#}


# Define this function to use another editor than vi. It will be called in one of two contexts:
#
# 1. When adding a new file to the password store
# 2. When editing an existing file in the password store
#
# When adding a new file if a OVERTAKE_EXT_template function exists, it's output will be piped in, but if this function does not exist the function will be called without input to stdin. Therefore, it must handle being called in both these ways:
#
# 1. <command that pipes unencrypted data> | edit_then_encrypt $FILE -
# 2. edit_then_encrypt $FILE
#
# The function needs to allow user to edit the plain text/decrypted content that is piped in. Content must be encrypted and written to $FILE in password_store. The FILE argument is an absolute path.
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
#  gpg --recipient "$PASSWORD_STORE_DEFAULT_RECIPIENTS" --output "$FILE" --encrypt "$tmp_file"
#
#  # Tidy up
#  rm "$tmp_file"
#}
#GENERAL OPTIONS
# C Compiler
CC := c++
# Compiler flags
CFLAGS := -Wall -Wextra -Werror -std=c++98
# Removal tool
RM := rm -rf


# PROGRAM
# Program name
NAME := ircserv
BIN_DIR := bin

# Headers
HEADER_DIR := .
HEADER :=
H_INCLUDE := $(addprefix -I, $(HEADER_DIR))

# Sources
SRC_DIR := src
SRC :=

# Objects
OBJ_DIR := build
OBJ := $(SRC:%.cpp=$(OBJ_DIR)/%.o)

# Inclusions:
INCLUDE := $(H_INCLUDE)

# Development
CFLAGS += -g
SRC := $(shell find src -name '*.cpp' -type f)
SRC_DIR := $(dir $(SRC))
SRC := $(notdir $(SRC))
OBJ := $(SRC:%.cpp=$(OBJ_DIR)/%.o)
HEADER := $(shell find src -name '*.hpp' -type f)
H_INCLUDE := $(sort $(addprefix -I, $(dir $(HEADER))))
INCLUDE := $(H_INCLUDE)

# vpath
vpath    %.hpp    $(HEADER_DIR)
vpath    %.cpp    $(SRC_DIR)


# -----------------------------------RULES------------------------------------ #
.PHONY: all vg clean fclean re run

# Creates NAME
all: $(BIN_DIR) $(NAME)

# Compiles OBJ into the program NAME
$(NAME): $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$@ $(OBJ) $(INCLUDE)

# Compiles SRC into OBJ
$(OBJ): $(OBJ_DIR)/%.o: %.cpp $(HEADER) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $@ -c $< $(INCLUDE)

# Directory making
$(OBJ_DIR):
	@mkdir -p $@

$(BIN_DIR):
	@mkdir -p $@

# Run program using valgrind
vg: all
	@valgrind --quiet --leak-check=full --show-leak-kinds=all $(BIN_DIR)/$(NAME)

# Clean: removes build directory
clean:
	$(RM) $(OBJ_DIR)

# Full clean: removes objects directory and bin directory
fclean: clean
	$(RM) $(BIN_DIR)

# Remake: remove build files and recompile the program
re: fclean all

# Run the program
run: all
	$(BIN_DIR)/$(NAME)

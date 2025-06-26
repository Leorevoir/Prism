ECHO    = /usr/bin/env echo -e
MKDIR   = /usr/bin/env mkdir -p
RM      = /usr/bin/env rm -rf

GREEN      	= \033[1;32m
RED        	= \033[1;31m
ILC			= \033[3m
ORANGE     	= \033[38;5;214m
RST		   	= \033[0m

NAME := prism_ls
SRC := $(wildcard src/*.cr)
MAX_THREADS = $(shell nproc)

BASE_FLAGS := --threads $(MAX_THREADS) --time --verbose --stats
DEBUG_FLAGS := --single-module --error-trace --define=debug
RELEASE_FLAGS := --release --no-debug

CRYSTAL := crystal

all: $(NAME)
	@$(ECHO) "$(GREEN)[✅] BUILD:    $(RST) $(ILC)completed$(RST)"

$(NAME): $(SRC)
	$(CRYSTAL) build $(BASE_FLAGS) $(RELEASE_FLAGS) $(SRC) -o $(NAME)
	@$(ECHO) "$(GREEN)[✅] COMPILED: $(RST) $(ILC)$(NAME)$(RST)"

debug: $(SRC)
	$(CRYSTAL) build $(BASE_FLAGS) $(DEBUG_FLAGS) $(SRC) -o $(NAME)
	@$(ECHO) "$(ORANGE)[🚧] COMPILED: $(RST) $(ILC)$(NAME) in debug mode$(RST)"

fclean:
	@$(RM) $(NAME)
	@$(ECHO) "$(RED)[❌] FCLEAN:   $(RST) Removed $(ILC)$(NAME)$(RST)"

re: fclean all

.PHONY: all fclean re
.SILENT:

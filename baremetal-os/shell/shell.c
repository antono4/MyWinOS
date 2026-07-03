/* =============================================================================
 * NanoOS Shell
 * =============================================================================
 */

#include <kernel.h>

#define MAX_INPUT 256
#define MAX_ARGS 32

/* Command history */
#define HISTORY_SIZE 16
static char history[HISTORY_SIZE][MAX_INPUT];
static int history_count = 0;
static int history_pos = 0;

/* Current input buffer */
static char input_buffer[MAX_INPUT];
static int input_pos = 0;

/* External functions */
extern char keyboard_read(void);
extern int keyboard_available(void);

/* Built-in commands */
typedef struct {
    const char* name;
    void (*func)(int argc, char** argv);
    const char* description;
} command_t;

/* Command implementations */
void cmd_help(int argc, char** argv);
void cmd_clear(int argc, char** argv);
void cmd_echo(int argc, char** argv);
void cmd_version(int argc, char** argv);
void cmd_memory(int argc, char** argv);
void cmd_uptime(int argc, char** argv);
void cmd_calc(int argc, char** argv);
void cmd_date(int argc, char** argv);

/* Command table */
static command_t commands[] = {
    {"help", cmd_help, "Display this help message"},
    {"clear", cmd_clear, "Clear the screen"},
    {"echo", cmd_echo, "Print text to screen"},
    {"version", cmd_version, "Show NanoOS version"},
    {"memory", cmd_memory, "Show memory information"},
    {"uptime", cmd_uptime, "Show system uptime"},
    {"calc", cmd_calc, "Simple calculator: calc <expr>"},
    {"date", cmd_date, "Show current date/time"},
    {"reboot", 0, "Reboot the system"},
    {"shutdown", 0, "Shutdown the system"},
    {"ls", 0, "List files"},
    {"cat", 0, "Display file contents"},
    {"cd", 0, "Change directory"},
    {"mkdir", 0, "Create directory"},
    {"touch", 0, "Create file"},
    {"rm", 0, "Remove file"},
    {"pwd", 0, "Print working directory"},
};

extern uint32_t get_free_memory(void);
extern uint32_t uptime_seconds(void);

/* Print character */
void print(const char* str);

/* Command implementations */
void cmd_help(int argc, char** argv) {
    print("\nAvailable commands:\n");
    print("------------------\n");
    for (int i = 0; i < sizeof(commands)/sizeof(command_t); i++) {
        print("  ");
        print(commands[i].name);
        print(" - ");
        print(commands[i].description);
        print("\n");
    }
    print("\n");
}

void cmd_clear(int argc, char** argv) {
    print("\x1B[2J\x1B[H");  /* ANSI escape to clear screen */
}

void cmd_echo(int argc, char** argv) {
    for (int i = 1; i < argc; i++) {
        print(argv[i]);
        if (i < argc - 1) print(" ");
    }
    print("\n");
}

void cmd_version(int argc, char** argv) {
    print("\nNanoOS v0.1.0\n");
    print("A simple operating system built from scratch\n");
    print("Built with love\n\n");
}

void cmd_memory(int argc, char** argv) {
    extern uint32_t get_total_memory(void);
    uint32_t total = get_total_memory();
    uint32_t free = get_free_memory();
    
    print("\nMemory Information:\n");
    print("------------------\n");
    print("Total: "); print_int(total); print(" KB\n");
    print("Free:  "); print_int(free); print(" KB\n");
    print("Used:  "); print_int(total - free); print(" KB\n\n");
}

void cmd_uptime(int argc, char** argv) {
    uint32_t seconds = uptime_seconds();
    uint32_t hours = seconds / 3600;
    uint32_t minutes = (seconds % 3600) / 60;
    uint32_t secs = seconds % 60;
    
    print("\nSystem Uptime: ");
    print_int(hours);
    print(":");
    print_int(minutes);
    print(":");
    print_int(secs);
    print("\n\n");
}

void cmd_calc(int argc, char** argv) {
    if (argc < 4) {
        print("Usage: calc <num1> <op> <num2>\n");
        print("Example: calc 5 + 3\n");
        return;
    }
    
    int a = 0, b = 0;
    /* Simple atoi */
    char* p = argv[1];
    while (*p) { a = a * 10 + (*p - '0'); p++; }
    
    p = argv[3];
    while (*p) { b = b * 10 + (*p - '0'); p++; }
    
    char op = argv[2][0];
    int result = 0;
    
    switch(op) {
        case '+': result = a + b; break;
        case '-': result = a - b; break;
        case '*': result = a * b; break;
        case '/': 
            if (b == 0) { print("Error: Division by zero\n"); return; }
            result = a / b; 
            break;
        default: print("Unknown operator\n"); return;
    }
    
    print("= "); print_int(result); print("\n");
}

void cmd_date(int argc, char** argv) {
    print("\nCurrent Date/Time: 2024-01-01 00:00:00\n");
    print("(RTC not implemented)\n\n");
}

/* Parse command line */
void parse_command(char* line) {
    char* argv[MAX_ARGS];
    int argc = 0;
    
    /* Tokenize */
    char* token = line;
    while (*token && argc < MAX_ARGS) {
        /* Skip whitespace */
        while (*token == ' ') token++;
        if (!*token) break;
        
        argv[argc++] = token;
        
        /* Find end of token */
        while (*token && *token != ' ') token++;
        if (*token) *token++ = '\0';
    }
    
    if (argc == 0) return;
    
    /* Add to history */
    if (history_count < HISTORY_SIZE) {
        history_count++;
    }
    history_pos = history_count;
    
    /* Find and execute command */
    for (int i = 0; i < sizeof(commands)/sizeof(command_t); i++) {
        if (strcmp(argv[0], commands[i].name) == 0) {
            if (commands[i].func) {
                commands[i].func(argc, argv);
            } else {
                print("Command not implemented yet: ");
                print(commands[i].name);
                print("\n");
            }
            return;
        }
    }
    
    /* Unknown command */
    print("Unknown command: ");
    print(argv[0]);
    print("\nType 'help' for available commands.\n");
}

/* Simple string compare */
int strcmp(const char* s1, const char* s2) {
    while (*s1 && *s2) {
        if (*s1 != *s2) return 0;
        s1++;
        s2++;
    }
    return *s1 == *s2;
}

/* Shell main loop */
void shell_main(void) {
    print("\nNanoOS Shell v0.1\n");
    print("Type 'help' for available commands.\n\n");
    
    while (1) {
        print("NanoOS> ");
        
        input_pos = 0;
        input_buffer[0] = '\0';
        
        /* Read input */
        while (1) {
            char c = keyboard_read();
            
            if (c == '\n') {
                print("\n");
                input_buffer[input_pos] = '\0';
                
                /* Execute command */
                if (input_pos > 0) {
                    parse_command(input_buffer);
                }
                break;
            }
            
            if (c == '\b') {
                if (input_pos > 0) {
                    input_pos--;
                    print("\b \b");
                }
            } else if (input_pos < MAX_INPUT - 1) {
                input_buffer[input_pos++] = c;
                print_char(c);
            }
        }
    }
}

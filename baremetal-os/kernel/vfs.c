/* =============================================================================
 * Virtual File System (VFS)
 * =============================================================================
 */

#include <kernel.h>

#define MAX_FILES 64
#define MAX_FILENAME 32

typedef struct vfs_node vfs_node_t;
typedef struct file file_t;

/* VFS node types */
typedef enum {
    FS_FILE,
    FS_DIRECTORY,
    FS_CHARDEVICE,
    FS_BLOCKDEVICE,
    FS_PIPE,
    FS_SYMLINK
} fs_node_type_t;

/* VFS node structure */
struct vfs_node {
    char name[MAX_FILENAME];
    fs_node_type_t type;
    uint32_t size;
    uint32_t permissions;
    uint32_t uid;
    uint32_t gid;
    void* device;
    
    /* Read/Write functions */
    uint32_t (*read)(vfs_node_t*, uint32_t, uint8_t*);
    uint32_t (*write)(vfs_node_t*, uint32_t, uint8_t*);
    
    /* Open/Close functions */
    void (*open)(vfs_node_t*);
    void (*close)(vfs_node_t*);
    
    /* Navigation */
    vfs_node_t* parent;
    vfs_node_t* children;
    int num_children;
};

/* File structure */
struct file {
    vfs_node_t* node;
    uint32_t position;
    int flags;
};

/* Root filesystem */
static vfs_node_t* root_fs = 0;

/* Initialize VFS */
void vfs_init(void) {
    /* Create root directory */
    root_fs = (vfs_node_t*)kmalloc();
    if (root_fs) {
        root_fs->name[0] = '/';
        root_fs->name[1] = '\0';
        root_fs->type = FS_DIRECTORY;
        root_fs->size = 0;
        root_fs->parent = 0;
        root_fs->children = 0;
        root_fs->num_children = 0;
    }
}

/* Create a file in VFS */
vfs_node_t* vfs_create_file(const char* name, vfs_node_t* parent) {
    vfs_node_t* node = (vfs_node_t*)kmalloc();
    if (node) {
        int i = 0;
        while (name[i] && i < MAX_FILENAME - 1) {
            node->name[i] = name[i];
            i++;
        }
        node->name[i] = '\0';
        node->type = FS_FILE;
        node->size = 0;
        node->parent = parent;
        node->children = 0;
        node->num_children = 0;
        node->read = 0;
        node->write = 0;
        node->open = 0;
        node->close = 0;
    }
    return node;
}

/* Create a directory in VFS */
vfs_node_t* vfs_create_directory(const char* name, vfs_node_t* parent) {
    vfs_node_t* node = vfs_create_file(name, parent);
    if (node) {
        node->type = FS_DIRECTORY;
    }
    return node;
}

/* Get root filesystem */
vfs_node_t* vfs_get_root(void) {
    return root_fs;
}

/* List directory contents */
void vfs_list_directory(vfs_node_t* dir) {
    if (dir && dir->type == FS_DIRECTORY) {
        vfs_node_t* child = dir->children;
        while (child) {
            /* Print filename */
            /* In real implementation, this would print to console */
            child = (vfs_node_t*)((uint32_t*)child)[-1];
        }
    }
}

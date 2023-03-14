import std/strutils

type NodeKind = enum
    nFile, nFolder

type Node = ref object
    name: string
    parent: Node
    case kind: NodeKind
    of nFolder:
        children: seq[Node]
    else:
        data: string

proc err(msg: string) =
    echo msg
    quit(0)

proc initFileSystem(): Node = Node(kind: nFolder, name: "root")

proc addFolderInFolder(folder: Node, name: string) =
    if folder.kind == nFile:
        err("cannot add folder to file")
        return
    folder.children.add Node(kind: nFolder, name: name)

proc addFileInFolder(folder: Node, name: string, data: string) =
    if folder.kind == nFile:
        err("cannot add file to file")
        return
    folder.children.add Node(kind: nFile, name: name, data: data)

proc searchImmediate(folder: Node, name: string): Node =
    for n in folder.children:
        if n.name == name:
            return n

proc returnNodeAtPath(folder: Node, path: seq[string]): Node =
    var p = folder.searchImmediate(path[0])
    if path.len != 1:
        p = p.returnNodeAtPath(path[1..path.high])
    return p

proc returnNodeAtPath(system: Node, path: string): Node =
    if path == "": err("error - path empty")
    if path == "root": return system
    var p = path.split('/')
    p = p[1..p.high]
    result = system.returnNodeAtPath(p)

proc treeInner(node: Node, level: uint) =
    if node.kind == nFolder: echo spaces(4*level), " 🗀 ", node.name
    else: echo spaces(4*level), " 🗎 ", node.name
    if node.kind == nFile: return
    if node.children.len != 0:
        for n in node.children:
            n.treeInner(level+1)

proc searchInner(node: Node, query, currentpath: string): (bool, string) =
    if node.name == query: return (true, currentpath & "/" & node.name)
    if node.kind == nFile: return (false, currentpath)
    if node.children.len != 0:
        for n in node.children:
            var q = n.searchInner(query, currentpath & "/" & node.name)
            if q[0]: return q

# ---------------------------------------------------------------------------- #

proc addFolder(system: Node, path: string, newFolderName: string) =
    if not system.returnNodeAtPath(path & "/" & newFolderName).isNil: err("cannot create: folder \"" & path & "\" already exists")
    let n = system.returnNodeAtPath(path)
    if n.isNil: err("cannot resolve path \"" & path & "\"")
    n.addFolderInFolder(newFolderName)

proc addFile(system: Node, path: string, newFileName: string, newFileData: string) =
    if not system.returnNodeAtPath(path & "/" & newFileName).isNil: 
        err("cannot create: file \"" & path & "\" already exists")
    let n = system.returnNodeAtPath(path)
    if n.isNil: 
        err("cannot resolve path \"" & path & "\"")
    n.addFileInFolder(newFileName, newFileData)

proc tree(system: Node) =
    for n in system.children:
        n.treeInner(0)

proc search(system: Node, query: string): string = # returns path to file or folder named [query]. if file is not found, path returned is blank.
    for n in system.children:
        var q = n.searchInner(query, "root")
        if q[0]: return q[1]
    return ""

# ---------------------------------------------------------------------------- #


var FS = initFileSystem()
FS.addFolder("root", "folder1")
FS.addFolder("root", "folder2")
FS.addFolder("root/folder2", "folder3")
FS.addFile("root/folder2/folder3", "A.txt", "LMAO")
FS.addFolder("root/folder2/folder3", "folder4")
FS.addFile("root/folder1", "B.txt", "LMAO")
echo FS.search("folder3")
FS.tree
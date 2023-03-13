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
        echo "cannot add folder to file"
        return
    folder.children.add Node(kind: nFolder, name: name)

proc addFileInFolder(folder: Node, name: string, data: string) =
    if folder.kind == nFile:
        echo "cannot add folder to file"
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
    let p = path.split('/')
    result = system.returnNodeAtPath(p)




proc addFolder(system: Node, path: string, newFolderName: string) =
    let p = returnNodeAtPath(path:)




# ---------------------------------------------------------------------------- #


var FS = initFileSystem()
echo FS.searchImmediate("br").isNil
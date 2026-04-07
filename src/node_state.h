#ifndef NODE_STATE_H
#define NODE_STATE_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/gdvirtual.gen.inc>

namespace godot
{

    class NodeState : public Node
    {
        GDCLASS(NodeState, Node)

    protected:
        static void _bind_methods();

    public:
        NodeState();
        ~NodeState();

        // Exposing hooks to GDScript to allow logic overriding
        GDVIRTUAL0(_on_enter)
        GDVIRTUAL0(_on_exit)
        GDVIRTUAL1(_on_process, double)
        GDVIRTUAL1(_on_physics_process, double)

        // Fast C++ wrappers to invoke the virtual methods
        void enter();
        void exit();
        void process(double delta);
        void physics_process(double delta);
    };

} // namespace godot

#endif // NODE_STATE_H
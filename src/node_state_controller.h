#ifndef NODE_STATE_CONTROLLER_H
#define NODE_STATE_CONTROLLER_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/string_name.hpp>
#include "node_state.h"

namespace godot
{

    class NodeStateController : public Node
    {
        GDCLASS(NodeStateController, Node)

    public:
        enum ProcessMode
        {
            PROCESS_IDLE,
            PROCESS_PHYSICS,
            PROCESS_BOTH
        };

    private:
        HashMap<StringName, NodeState *> states;
        NodeState *current_state = nullptr;
        NodeState *initial_node = nullptr;
        ProcessMode process_mode = PROCESS_BOTH;

    protected:
        static void _bind_methods();

    public:
        NodeStateController();
        ~NodeStateController();

        void _ready() override;
        void _process(double delta) override;
        void _physics_process(double delta) override;

        void set_initial_node(NodeState *node);
        NodeState *get_initial_node() const;

        void set_process_mode(ProcessMode mode);
        ProcessMode get_process_mode() const;

        void transition_to(const StringName &state_name);
    };

} // namespace godot

// Required to expose the custom enum to Godot's reflection system
VARIANT_ENUM_CAST(NodeStateController::ProcessMode);

#endif // NODE_STATE_CONTROLLER_H
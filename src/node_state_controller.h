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

    private:
        HashMap<StringName, NodeState *> states;
        NodeState *current_state = nullptr;
        StringName initial_state_name;

    protected:
        static void _bind_methods();

    public:
        NodeStateController();
        ~NodeStateController();

        void _ready() override;
        void _process(double delta) override;
        void _physics_process(double delta) override;

        void set_initial_state_name(const StringName &name);
        StringName get_initial_state_name() const;

        void transition_to(const StringName &state_name);
    };

} // namespace godot

#endif // NODE_STATE_CONTROLLER_H
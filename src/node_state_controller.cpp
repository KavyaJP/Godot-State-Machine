#include "node_state_controller.h"
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void NodeStateController::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_initial_node", "node"), &NodeStateController::set_initial_node);
    ClassDB::bind_method(D_METHOD("get_initial_node"), &NodeStateController::get_initial_node);
    ClassDB::bind_method(D_METHOD("transition_to", "state_name"), &NodeStateController::transition_to);

    ClassDB::bind_method(D_METHOD("set_process_mode", "mode"), &NodeStateController::set_process_mode);
    ClassDB::bind_method(D_METHOD("get_process_mode"), &NodeStateController::get_process_mode);

    // Register enum bindings for the inspector dropdown
    BIND_ENUM_CONSTANT(PROCESS_IDLE);
    BIND_ENUM_CONSTANT(PROCESS_PHYSICS);
    BIND_ENUM_CONSTANT(PROCESS_BOTH);

    ADD_PROPERTY(PropertyInfo(Variant::INT, "process_mode", PROPERTY_HINT_ENUM, "Idle,Physics,Both"), "set_process_mode", "get_process_mode");
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "initial_node", PROPERTY_HINT_NODE_TYPE, "NodeState"), "set_initial_node", "get_initial_node");

    ADD_SIGNAL(MethodInfo("state_changed", PropertyInfo(Variant::OBJECT, "old_state", PROPERTY_HINT_NODE_TYPE, "NodeState"), PropertyInfo(Variant::OBJECT, "new_state", PROPERTY_HINT_NODE_TYPE, "NodeState")));
}

NodeStateController::NodeStateController()
{
}

NodeStateController::~NodeStateController()
{
}

void NodeStateController::set_initial_node(NodeState *node)
{
    initial_node = node;
}

NodeState *NodeStateController::get_initial_node() const
{
    return initial_node;
}

void NodeStateController::set_process_mode(ProcessMode mode)
{
    process_mode = mode;
}

NodeStateController::ProcessMode NodeStateController::get_process_mode() const
{
    return process_mode;
}

void NodeStateController::_ready()
{
    if (Engine::get_singleton()->is_editor_hint())
    {
        return;
    }

    int child_count = get_child_count();
    for (int i = 0; i < child_count; ++i)
    {
        Node *child = get_child(i);
        NodeState *state = Object::cast_to<NodeState>(child);

        if (state)
        {
            StringName state_name = state->get_name();
            states[state_name] = state;
            state->connect("transition", Callable(this, "transition_to"));
        }
    }

    if (initial_node != nullptr)
    {
        transition_to(initial_node->get_name());
    }
    else
    {
        UtilityFunctions::push_warning("NodeStateController: No valid initial node provided.");
    }
}

void NodeStateController::_process(double delta)
{
    if (Engine::get_singleton()->is_editor_hint() || !current_state)
    {
        return;
    }

    if (process_mode == PROCESS_IDLE || process_mode == PROCESS_BOTH)
    {
        current_state->call("_on_process", delta);
    }
}

void NodeStateController::_physics_process(double delta)
{
    if (Engine::get_singleton()->is_editor_hint() || !current_state)
    {
        return;
    }

    if (process_mode == PROCESS_PHYSICS || process_mode == PROCESS_BOTH)
    {
        current_state->call("_on_physics_process", delta);
    }
}

void NodeStateController::transition_to(const StringName &state_name)
{
    if (!states.has(state_name))
    {
        UtilityFunctions::push_error("NodeStateController: Transition failed. State '", state_name, "' does not exist.");
        return;
    }

    if (current_state && current_state->get_name() == state_name)
    {
        return;
    }

    NodeState *old_state = current_state;

    if (current_state)
    {
        current_state->call("_on_exit");
    }

    current_state = states[state_name];

    if (current_state)
    {
        current_state->call("_on_enter");
    }

    // Broadcast the change to external systems (e.g., UI, AnimationTree)
    emit_signal("state_changed", old_state, current_state);
}
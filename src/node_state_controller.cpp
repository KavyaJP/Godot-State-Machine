#include "node_state_controller.h"
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void NodeStateController::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_initial_state_name", "name"), &NodeStateController::set_initial_state_name);
    ClassDB::bind_method(D_METHOD("get_initial_state_name"), &NodeStateController::get_initial_state_name);
    ClassDB::bind_method(D_METHOD("transition_to", "state_name"), &NodeStateController::transition_to);

    // Expose initial_state to the inspector
    ADD_PROPERTY(PropertyInfo(Variant::STRING_NAME, "initial_state"), "set_initial_state_name", "get_initial_state_name");
}

NodeStateController::NodeStateController()
{
}

NodeStateController::~NodeStateController()
{
}

void NodeStateController::set_initial_state_name(const StringName &name)
{
    initial_state_name = name;
}

StringName NodeStateController::get_initial_state_name() const
{
    return initial_state_name;
}

void NodeStateController::_ready()
{
    // Prevent the state machine logic from executing inside the editor view
    if (Engine::get_singleton()->is_editor_hint())
    {
        return;
    }

    // Cache valid child states for O(1) lookups during gameplay transitions
    int child_count = get_child_count();
    for (int i = 0; i < child_count; ++i)
    {
        Node *child = get_child(i);
        NodeState *state = Object::cast_to<NodeState>(child);

        if (state)
        {
            StringName state_name = state->get_name();
            states[state_name] = state;

            // Route the state's transition requests to the controller's transition method
            state->connect("transition", Callable(this, "transition_to"));
        }
    }

    if (!initial_state_name.is_empty() && states.has(initial_state_name))
    {
        transition_to(initial_state_name);
    }
    else
    {
        UtilityFunctions::push_warning("NodeStateController: No valid initial state provided.");
    }
}

void NodeStateController::_process(double delta)
{
    if (Engine::get_singleton()->is_editor_hint())
    {
        return;
    }

    if (current_state)
    {
        current_state->call("_on_process", delta);
    }
}

void NodeStateController::_physics_process(double delta)
{
    if (Engine::get_singleton()->is_editor_hint())
    {
        return;
    }

    if (current_state)
    {
        current_state->call("_on_physics_process", delta);
    }
}

void NodeStateController::transition_to(const StringName &state_name)
{
    if (!states.has(state_name))
    {
        UtilityFunctions::push_error("NodeStateController: Attempted transition to unknown state - ", state_name);
        return;
    }

    if (current_state)
    {
        current_state->call("_on_exit");
    }

    current_state = states[state_name];

    if (current_state)
    {
        current_state->call("_on_enter");
    }
}
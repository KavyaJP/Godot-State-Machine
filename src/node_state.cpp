#include "node_state.h"

using namespace godot;

void NodeState::_bind_methods()
{
    GDVIRTUAL_BIND(_on_enter);
    GDVIRTUAL_BIND(_on_exit);
    GDVIRTUAL_BIND(_on_process, "delta");
    GDVIRTUAL_BIND(_on_physics_process, "delta");

    ADD_SIGNAL(MethodInfo("transition", PropertyInfo(Variant::STRING_NAME, "state_name")));
}

NodeState::NodeState() {}

NodeState::~NodeState() {}

// --- Fast GDVIRTUAL Wrappers ---

void NodeState::enter()
{
    GDVIRTUAL_CALL(_on_enter);
}

void NodeState::exit()
{
    GDVIRTUAL_CALL(_on_exit);
}

void NodeState::process(double delta)
{
    GDVIRTUAL_CALL(_on_process, delta);
}

void NodeState::physics_process(double delta)
{
    GDVIRTUAL_CALL(_on_physics_process, delta);
}
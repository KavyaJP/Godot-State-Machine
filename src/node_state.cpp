#include "node_state.h"

using namespace godot;

void NodeState::_bind_methods()
{
    // Bind virtual methods to ensure the Godot engine recognizes them for GDScript overrides
    GDVIRTUAL_BIND(_on_enter);
    GDVIRTUAL_BIND(_on_exit);
    GDVIRTUAL_BIND(_on_process, "delta");
    GDVIRTUAL_BIND(_on_physics_process, "delta");

    // Registering the signal here to ensure it's available to emit from GDScript.
    // Using StringName enforces fast hashed comparisons internally.
    ADD_SIGNAL(MethodInfo("transition", PropertyInfo(Variant::STRING_NAME, "state_name")));
}

NodeState::NodeState()
{
}

NodeState::~NodeState()
{
}
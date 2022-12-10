function ix_networks_to_remove=get_ix_networks_to_remove(ix_networks_to_keep,n_systems)

foo=1:n_systems;
ix_networks_to_remove=ismember(foo,ix_networks_to_keep);
ix_networks_to_remove=(foo(~ix_networks_to_remove));
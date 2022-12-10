function y = force_ref_higher_than_others(local_data,ix_ref)

y=local_data;
if median(local_data(ix_ref))<median(local_data(~ix_ref))
    y=-local_data;
end
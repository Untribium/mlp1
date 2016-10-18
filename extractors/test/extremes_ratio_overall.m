function[score] = extremes_ratio_overall(brain)

max_value = double(max(brain(:)));
min_value = double(min(brain(brain > 0)));

score = max_value/min_value;
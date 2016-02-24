function k = rand_state(p)
  k=find(rand < cumsum(p),1);

 
##Krys Imput.. idols_ai? whatever, i need to personalise all this later
  let
    idols_ai = "ssh-ed25519 123 root@kry";
    recovery_key = "ssh-ed25519 123 ryan@agenix-recovery";
    systems = [
    idol_ai

    recovery_key
    ];
    {
      "./xxx.age".publicKeys = users ++ systems;
    }

 
##Krys Imput.. idols_ai? whatever, i need to personalise all this later
   ##and so 1 week later i am.
  let
    
    pc-ai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAYmU24eBlK1jM/zYLfcFkp5nzPLPZjJgDaIRsI3Fo1 xtrasodiumchloride2@gmail.com";

    recovery_key = "SHA256:JQlyeyGfOeeDdMVc3sQ2doFGdLUrunl8VuaZ1VGJCmA kry@agenix-recovery";
    
    systems = [
    
    pc-ai

    recovery_key
    
    ];
    {
      "./xxx.age".publicKeys = users ++ systems;
    }

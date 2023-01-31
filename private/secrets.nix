let
  gabehoban = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+3hs7Qa+XVmHConIc1q8KTphIP98UjMPJfNCvQU+h0 master_key@gabehoban";
  users = [ gabehoban ];
in
{
  "github-token.age".publicKeys = [ gabehoban ];
  "password.age".publicKeys = [ gabehoban ];
}

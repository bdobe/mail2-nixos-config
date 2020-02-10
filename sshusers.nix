{ pkgs, ... }:

# Setup users. To add a new user:
# 1. Add the name of the user to the list in the second-to-last line
# 2. Make sure that the git repo contains the key as "$USER.pub"
# 3. Make sure that the commit ("rev") contains the latest commit hash. If it correct, jump to step 7.
# 4. If you changed the commit, manipulate the sha512 entry by changing the first character from 0 to 1 or 1 to 0.
# 5. Run "nixos-rebuild build"
# 6. Wait for a message about an invalid hash and replace the hash in this file with the new one.
# 7. Run "nixos-rebuild switch"
# 8. Let the user login and change their password

let
  sshkeys = pkgs.fetchFromGitHub {
    owner = "freifunkhamburg";
    repo = "ssh-keys";
    rev = "70a8f1a4b8ddf921579986fb08b45050abeef2bc";
    sha512 = "05p3ypg5imjxiswsspiix1l783w11ddby78bwjv0dnppbz8i4ddiy8fz70vcz4q2fbb94kwnk5zm7mz53h24z3j97xq9d485nmxinpq";
  };
  getpubkeys = user: builtins.readFile "${sshkeys}/${user}.pub";
  mkuser = user: { name = user; isNormalUser = true; extraGroups = [ "wheel" ]; initialPassword = "test1234"; openssh.authorizedKeys.keys = [ (getpubkeys user) ]; };
  mkusers = users: map (mkuser) users;
in
{
  users.users = mkusers [ "tokudan" "Entil_Zha" "alexander" ] ++ [
    { name = "jamonitor"; isNormalUser = true; extraGroups = [ "wheel" ]; openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdIGniuakk1Li8gkpGABVBgkkUGGWYcM9qQRgcuYiKK/agidZ9KQ6YktOjakWsSPRpB2OHzr8GHaVpKMNlkAsq4W20d9RrO1+FrP96rNm/Op3X10SDNMdD5qcMq36BWxMig/8L75pbGqEZmcOi4/ZbgzaTh+lWTGG/1d2xwzi99BO0YeimDoZ+fAOqxfJAVirJVBuhqf+H9FGkD1G6zdDv+EzOnj4TT70LFNC90NoVFvus2nxVv8vY1kLLVSkNMIgZXn87A7GcmjrKUmONcfx/rgkt2VwsKS7Cj2YWz8ihiy7p5wg+oS/62BTFbKcLwwpcBaMwLiESuj1+fRgjwkwaqWcVeJAzjsAuLtGtIOWeWXCUlkyv9WoFE7he0tTB76tW5ysy3ibMmFE3duPAtn7Q3Rsu4n4UL2kKdtjVqFsW3AkTi+U7gsd17K84VoCf5Is2hNqKzjXBdCs/a57ZcrwOmMqGJZJp49XTW8EEAT/Emur0b2J4BcF4z/3oqrs/h8LIyoSjLhamT9EoODHb/6iz/xRbymCzoiu1CMRUQuqThlqe7uN5InjOyXbaWmjdN+svRik4CzQ9J+xCkuw+BzhwsPu8EKV5Yo4Uvpr6UTxXzuHN5GxrUFwD8d7VBSJPuY6DfhSNwCIPB2awUxXwFhdENM2zFWEbzGQcZ1DhUh3/5w=="
    ]; }
  ];
}

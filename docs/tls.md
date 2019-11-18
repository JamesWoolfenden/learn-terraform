# Transport Layer Security - TLS

The TLS provider can be used to generate SSH keys, CSR's and self signed certs for SSL.

## SSH keys

```terraform
resource "tls_private_key" "ssh" {
  count     = length(var.key_names)
  algorithm = "RSA"
  rsa_bits  = "2048"
}
```

Applying the full example in the *./examples/tls* gives:

```terraform
Outputs:

ssh = [
  {
    "algorithm" = "RSA"
    "ecdsa_curve" = "P224"
    "id" = "f64e9d90fea972869fed88ea8f0323bd47cb66b1"
    "private_key_pem" = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAwCkXvggXmU/Mp/vBsQPVvydWayfvRkhz3nCyXblgSB+3I2VV\nFrJINGggysbpWo6XXYVSYR7iJ0PmwmzgfFpWSs8dq4q0ixnkOluV/BHGN6VSSF3m\nlC63Kqjy0xF8nnMLGu0Kfz/uqCQ3oshmE7YFMGuxfquRy1g733omMz3SeO9IzLZe\np4bxbMGuEnKJ5dRTgfuyFf69wBRbeyqCggxFjyuhr2zmmEWqGopXzFsls1n5XakE\ntDLrYd8+nhrs+fZi3EnOxT2uGqB2Jg9FUx/tqo69FcyiWExD1LX77aQzPZxac4Eo\nb1URzyq7Aq6mqDa9qQ/8KPaRSWT7PAqTlLqxNQIDAQABAoIBAQCjU4oJi+k69teV\nQ+dqZD8N3QqXw3adP0G0pAcGoGRUiRho7lz3EItMd+C/WXfH74B6DbJqOAyyoQUG\n5fGb4FCN/yJRxnAT9urEK0n82MKoU0zvk1hDRL2MddMGUUuhhVjABw+v/pADu9zJ\n8BjK0h/w+uf/KSafNhyVosXLMdWt0QKfzV/+NPb2hsyBqeY1EVlRhHYbydF+44Da\nTqt9hViQJeUkoUr/S1ZJnug90I66wy+DweZkJTtIq6+xgE7Iiyx3J0nSl2H3xE5Z\nH/h61n+MxqUV9nyUN06jKZO/XpkQYAdLVAlnbYvsRdLOjqebxvt1cPn7vdUPH+5a\noaKwUgd1AoGBAOfnwp+J5iDoDTyCNkd3gqqqi20Jz6lY3o1yIPGc6GyFiWVRifSZ\nZkqs++oP0ILyLGIl6f7iN7jwfUlt+mqrkHCmbkkThNKVVb7gF5HePYi5jeX938Ld\nLmU7de2GwCxv0pdqQbQ65FUk4DIOIE0IjYJf4lD4wqEs2ScnRBtbpg57AoGBANQg\nMlZ1GtnG02VsfMRLcFpmqJfOwucDAzJw0BLMld1cKb3g7w6UK5Y+BpKg1sbJ8CXs\nG0c34r2lR1GeL/C+exm/Hxlac5K9qHqcgB/nlPePX64JTtkwzZYMEPDEt5CWDe2m\nv8UcoAo6uYAR4mSM7jHzKCD5tOpblj2GUItg5AgPAoGAHWp3dHcwerIUo708l1og\nd/eEEgOxlKCSMkzswtkNXl6d6/0oy579q7E/jxQMdd+0I4r9oHgfa1UN/1d08Tzr\n6G4kBR71tSR+KOUR+E3BbmtjBW5riLM3pF2jesqh68EPbGdtCCiEOAyiZ5cFH+Ba\n2tPAyFaVkY43yVCgwfuhF6sCgYBAiYcnHLvNlBtO2UHgat9E8cTLYwGTTSxU1VPI\n1GuoDFk6xsuUkOnt7PMM+1g85MVmlD38XfljH3ziTRFi2mEThT1N9mIBPCidHS4y\nBsAgzYMbrQNLOvjhdMxWpFMA71ZPfpMLwljCo/k6CLbrRqFVmxgTaEVto+3CzDGH\nJjRaawKBgEDRxLBImavHr6HjGE6jC1+tD5rH4TsC+Bbuht9dgwxUS2rm623NbMmv\nW8Yz5fi4Pc2l0mx1gB6J1i13g99PNSMGzml3xXGX3Zq65tLCcRUjp1emCtCifFrP\nTq1FqcO5RYTguLg5b6ziAVQQ2hYzZm0ogJ/mrBgE+49PVxK55Xyt\n-----END RSA PRIVATE KEY-----\n"
    "public_key_fingerprint_md5" = "f6:4b:3d:cc:0a:f6:28:d4:d1:5d:8d:87:05:2d:51:ab"
    "public_key_openssh" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAKRe+CBeZT8yn+8GxA9W/J1ZrJ+9GSHPecLJduWBIH7cjZVUWskg0aCDKxulajpddhVJhHuInQ+bCbOB8WlZKzx2rirSLGeQ6W5X8EcY3pVJIXeaULrcqqPLTEXyecwsa7Qp/P+6oJDeiyGYTtgUwa7F+q5HLWDvfeiYzPdJ470jMtl6nhvFswa4Sconl1FOB+7IV/r3AFFt7KoKCDEWPK6GvbOaYRaoailfMWyWzWfldqQS0Muth3z6eGuz59mLcSc7FPa4aoHYmD0VTH+2qjr0VzKJYTEPUtfvtpDM9nFpzgShvVRHPKrsCrqaoNr2pD/wo9pFJZPs8CpOUurE1\n"
    "public_key_pem" = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwCkXvggXmU/Mp/vBsQPV\nvydWayfvRkhz3nCyXblgSB+3I2VVFrJINGggysbpWo6XXYVSYR7iJ0PmwmzgfFpW\nSs8dq4q0ixnkOluV/BHGN6VSSF3mlC63Kqjy0xF8nnMLGu0Kfz/uqCQ3oshmE7YF\nMGuxfquRy1g733omMz3SeO9IzLZep4bxbMGuEnKJ5dRTgfuyFf69wBRbeyqCggxF\njyuhr2zmmEWqGopXzFsls1n5XakEtDLrYd8+nhrs+fZi3EnOxT2uGqB2Jg9FUx/t\nqo69FcyiWExD1LX77aQzPZxac4Eob1URzyq7Aq6mqDa9qQ/8KPaRSWT7PAqTlLqx\nNQIDAQAB\n-----END PUBLIC KEY-----\n"
    "rsa_bits" = 2048
  },
]
```
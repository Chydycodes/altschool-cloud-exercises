# Exercise 6

### Task:

Review the CIS benchmark for ubuntu, and try to implement at least 10 of the recommendations that we made within the benchmark.

### Focus Areas :

Recommendations cutting across the areas listed below; 

1. Initial Setup
2. Services
3. Network Configuration
4. Logging and Auditing
5. Access, Authentication and Authorization
6. System Maintenance


## INITIAL SETUP

#### 1.1 Filesystem configuration

This recommendation requires directories used for system-wide functions can be further protected by placing
them on separate partitions. This provides protection for resource exhaustion and enables
the use of mounting options that are applicable to the directory's intended use.

#### 1.1.23 Disable Automounting (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 2 - Workstation

#### Description:

autofs allows automatic mounting of devices, typically including CD/DVDs and USB drives.

#### Rationale:

With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in system even if they lacked permissions to mount it themselves.

#### Impact:
The use of portable hard drives is very common for workstation users. If your organization allows the use of portable storage or media on workstations and physical access controls to workstations is considered adequate there is little value add in turning off automounting.

####Audit:
autofs should be removed or disabled. Run the following commands to verify that autofs is not installed or is disabled

`dpkg -s autofs`

Output should include: 

package `autofs` is not installed

#### My Output:

### 1.4 Secure Boot Settings
The recommendations in this section focus on securing the bootloader and settings involved in the boot process directly.

#### 1.4.4 Ensure authentication required for single user mode (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:
Single user mode is used for recovery when the system detects an issue during boot or by manual selection from the bootloader.

#### Rationale:

Requiring authentication in single user mode prevents an unauthorized user from rebooting the system into single user to gain root privileges without credentials.

#### Audit:

Perform the following to determine if a password is set for the root user:

 `grep -Eq '^root:\$[0-9]' /etc/shadow || echo "root is locked" `
 
 #### My Output :
 
No results should be returned.

## 2. SERVICES

#### 2.1 Special Purpose Services
This section describes services that are installed on systems that specifically need to run these services. If any of these services are not required, it is recommended that they be deleted from the system to reduce the potential attack surface. If a package is required as a dependency, and the service is not required, the service should be stopped and masked.

#### 2.1.1.1 Ensure time synchronization is in use (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:
System time should be synchronized between all systems in an environment. This is typically done by establishing an authoritative time server or set of servers and having all systems synchronize their clocks to them.

> Notes:
- If access to a physical host's clock is available and configured according to site policy, this section can be skipped
 
- Only one time synchronization method should be in use on the system

- If access to a physical host's clock is available and configured according to site policy, systemd-timesyncd should be stopped and masked

#### Rationale:

Time synchronization is important to support time sensitive security mechanisms like Kerberos and also ensures log files have consistent time records across the enterprise, which aids in forensic investigations.

#### Audit:
On physical systems or virtual systems where host based time synchronization is not available verify that timesyncd, chrony, or NTP is installed. Use one of the following commands to determine the needed information:

If systemd-timesyncd is used:

 `systemctl is-enabled systemd-timesyncd`
 
If chrony is used:

`dpkg -s chrony`

If ntp is used:

`dpkg -s ntp`

#### My Output:


#### 2.1.5 Ensure DHCP Server is not installed (Automated)

#### Profile Applicability:
- Level 1 - Server
 
- Level 1 - Workstation

#### Description:

The Dynamic Host Configuration Protocol (DHCP) is a service that allows machines to be dynamically assigned IP addresses.

#### Rationale:
Unless a system is specifically set up to act as a DHCP server, it is recommended that this package be removed to reduce the potential attack surface.
#### Audit:

Run the following commands to verify isc-dhcp-server is not installed: `dpkg -s isc-dhcp-server | grep -E '(Status:|not installed)' `

#### My Output :

## 3. NETWORK CONFIGURATION

#### 3.5 Firewall Configuration
A firewall is a set of rules. When a data packet moves into or out of a protected network space, its contents (in particular, information about its origin, target, and the protocol it plans to use) are tested against the firewall rules to see if it should be allowed through

#### 3.5.1.1 Ensure ufw is installed (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

The Uncomplicated Firewall (ufw) is a frontend for iptables and is particularly well-suited for host-based firewalls. ufw provides a framework for managing netfilter, as well as a command-line interface for manipulating the firewall

#### Rationale:

A firewall utility is required to configure the Linux kernel's netfilter framework via the iptables or nftables back-end. The Linux kernel's netfilter framework host-based firewall can protect against threats originating from within a corporate network to include malicious mobile code and poorly configured software on a host.

> Note: Only one firewall utility should be installed and configured. UFW is dependent on the iptables package

#### Audit:

Run the following command to verify that Uncomplicated Firewall (UFW) is installed:

` dpkg -s ufw | grep 'Status: install' `

My Output: 

## 4. LOGGING AND AUDITING

System auditing, through auditd, allows system administrators to monitor their systems such that they can detect unauthorized access or modification of data. By default, auditd will audit AppArmor AVC denials, system logins, account modifications, and authentication events. Events will be logged to /var/log/audit/audit.log. The recording of these events will use a modest amount of disk space on a system. If significantly more events are captured, additional on system or off system storage may need to be allocated.

#### 4.2.2.1 Ensure journald is configured to send logs to rsyslog (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

Data from journald may be stored in volatile memory or persisted locally on the server. Utilities exist to accept remote export of journald logs, however, use of the rsyslog service provides a consistent means of log collection and export.

#### Rationale:

Storing log data on a remote host protects log integrity from local attacks. If an attacker gains root access on the local system, they could tamper with or remove log data that is stored on the local system.

#### Audit:

Review /etc/systemd/journald.conf and verify that logs are forwarded to syslog with the following commands

`grep -e ForwardToSyslog /etc/systemd/journald.conf`

My Output:

## 5. ACCESS, AUTHENTICATION AND AUTHORIZATION

#### 5.1 Configure time-based job schedulers 

cron is a time-based job scheduler used to schedule jobs, commands or shell scripts, to run periodically at fixed times, dates, or intervals. at provides the ability to execute a command or shell script at a specified date and hour, or after a given interval of time.

#### 5.1.1 Ensure cron daemon is enabled and running (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

The cron daemon is used to execute batch jobs on the system.

> Note: Other methods, such as systemd timers, exist for scheduling jobs. If another method is used, cron should be removed, and the alternate method should be secured in accordance with local site policy

#### Rationale:
While there may not be user jobs that need to be run on the system, the system does have maintenance jobs that may include security monitoring that have to run, and cron is used to execute them.

#### Audit:

Run the following command to verify cron is enabled:

`systemctl is-enabled cron`
enabled

Run the following command to verify that cron is running:

`systemctl status cron | grep 'Active: active (running) '`

My Output:

#### 5.2 Configure sudo

sudo allows a permitted user to execute a command as the superuser or another user, as specified by the security policy. The invoking user's real (not effective) user ID is used to determine the user name with which to query the security policy

#### 5.2.1 Ensure sudo is installed (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

sudo allows a permitted user to execute a command as the superuser or another user, as specified by the security policy. The invoking user's real (not effective) user ID is used to determine the user name with which to query the security policy.

> Note: Use the sudo-ldap package if you need LDAP support for sudoers

#### Rationale:

sudo supports a plugin architecture for security policies and input/output logging. Third parties can develop and distribute their own policy and I/O logging plugins to work seamlessly with the sudo front end. The default security policy is sudoers, which is configured via the file /etc/sudoers. The security policy determines what privileges, if any, a user has to run sudo. The policy may require that users authenticate themselves with a password or another authentication mechanism. If authentication is required, sudo will exit if the user's password is not entered within a configurable time limit. This limit is policy-specific.

#### Audit:

Verify that sudo in installed.

Run the following command and inspect the output to confirm that sudo is installed:

`dpkg -s sudo`

My Output: 

## 6. SYSTEM MAINTENANCE

#### 6.1 System File Permissions

This section provides guidance on securing aspects of system files and directories

#### 6.1.2 Ensure permissions on /etc/passwd are configured (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

The /etc/passwd file contains user account information that is used by many system utilities and therefore must be readable for these utilities to operate.

#### Rationale:

It is critical to ensure that the /etc/passwd file is protected from unauthorized write access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions.

#### Audit:

Run the following command and verify Uid and Gid are both 0/root and Access is 644:

 `stat /etc/passwd`
 
 My Output:
 
 
### 6.2 User and Group Settings

This section provides guidance on securing aspects of the users and groups. Note: The recommendations in this section check local users and groups. Any users or groups
from other sources such as LDAP will not be audited. In a domain environment similar checks should be performed against domain users and groups.

#### 6.2.1 Ensure accounts in /etc/passwd use shadowed passwords (Automated)

#### Profile Applicability:

- Level 1 - Server

- Level 1 - Workstation

#### Description:

Local accounts can uses shadowed passwords. With shadowed passwords, The passwords are saved in shadow password file, /etc/shadow, encrypted by a salted one-way hash. Accounts with a shadowed password have an x in the second field in /etc/passwd.

#### Rationale:

The /etc/passwd file also contains information like user ID's and group ID's that are used by many system programs. Therefore, the /etc/passwd file must remain world readable. In spite of encoding the password with a randomly-generated one-way hash function, an attacker could still break the system if they got access to the /etc/passwd file. This can be mitigated by using shadowed passwords, thus moving the passwords in the /etc/passwd file to /etc/shadow. The /etc/shadow file is set so only root will be able to read and write. This helps mitigate the risk of an attacker gaining access to the encoded passwords with which to perform a dictionary attack.

> Notes:
- All accounts must have passwords or be locked to prevent the account from being usedby an unauthorized user.

- A user account with an empty second field in /etc/passwd allows the account to be logged into by providing only the username.

#### Audit:

Run the following command and verify that no output is returned:

` awk -F: '($2 != "x" ) { print $1 " is not set to shadowed passwords "}' /etc/passwd `

My Output

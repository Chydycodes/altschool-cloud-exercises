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

1.1 ####Filesystem configuration

This recommendation requires directories used for system-wide functions can be further protected by placing
them on separate partitions. This provides protection for resource exhaustion and enables
the use of mounting options that are applicable to the directory's intended use.

1.1.23 ####Disable Automounting (Automated)

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

1.4  ### Secure Boot Settings
The recommendations in this section focus on securing the bootloader and settings involved in the boot process directly.

1.4.4 #### Ensure authentication required for single user mode (Automated)

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

2. # SERVICES

2.1 #### Special Purpose Services
This section describes services that are installed on systems that specifically need to run these services. If any of these services are not required, it is recommended that they be deleted from the system to reduce the potential attack surface. If a package is required as a dependency, and the service is not required, the service should be stopped and masked.

2.1.1.1 #### Ensure time synchronization is in use (Automated)

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


2.1.5 #### Ensure DHCP Server is not installed (Automated)

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


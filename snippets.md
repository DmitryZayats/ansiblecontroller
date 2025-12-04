# Search tags
    ansible.builtin.file
    ansible.builtin.copy
    ansible.builtin.fetch
    ansible.builtin.shell
    ansible.builtin.lineinfile
    ansible.builtin.blockinfile
    ansible.builtin.debug
    community.general.mail

# Manage files and file properties

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/file_module.html


```
    - name: Remove default report file name if found
      ansible.builtin.file:
        path: /ansible/reports/{{ report_name }}.csv
        state: absent
      delegate_to: localhost
      run_once: true
```
```
    - name: Change file ownership, group and permissions
      ansible.builtin.file:
        path: /etc/foo.conf
        owner: foo
        group: foo
        mode: '0644'

    - name: Give insecure permissions to an existing file
      ansible.builtin.file:
        path: /work
        owner: root
        group: root
        mode: '1777'

    - name: Create a symbolic link
      ansible.builtin.file:
        src: /file/to/link/to
        dest: /path/to/symlink
        owner: foo
        group: foo
        state: link

    - name: Create two hard links
      ansible.builtin.file:
        src: '/tmp/{{ item.src }}'
        dest: '{{ item.dest }}'
        state: hard
      loop:
        - { src: x, dest: y }
        - { src: z, dest: k }

    - name: Touch a file, using symbolic modes to set the permissions (equivalent to 0644)
      ansible.builtin.file:
        path: /etc/foo.conf
        state: touch
        mode: u=rw,g=r,o=r

    - name: Touch the same file, but add/remove some permissions
      ansible.builtin.file:
        path: /etc/foo.conf
        state: touch
        mode: u+rw,g-wx,o-rwx

    - name: Touch again the same file, but do not change times this makes the task idempotent
      ansible.builtin.file:
        path: /etc/foo.conf
        state: touch
        mode: u+rw,g-wx,o-rwx
        modification_time: preserve
        access_time: preserve

    - name: Create a directory if it does not exist
      ansible.builtin.file:
        path: /etc/some_directory
        state: directory
        mode: '0755'

    - name: Update modification and access time of given file
      ansible.builtin.file:
        path: /etc/some_file
        state: file
        modification_time: now
        access_time: now

    - name: Set access time based on seconds from epoch value
      ansible.builtin.file:
        path: /etc/another_file
        state: file
        access_time: '{{ "%Y%m%d%H%M.%S" | strftime(stat_var.stat.atime) }}'

    - name: Recursively change ownership of a directory
      ansible.builtin.file:
        path: /etc/foo
        state: directory
        recurse: yes
        owner: foo
        group: foo

    - name: Remove file (delete file)
      ansible.builtin.file:
        path: /etc/foo.txt
        state: absent

    - name: Recursively remove directory
      ansible.builtin.file:
        path: /etc/foo
        state: absent
```

# Copy files to remote locations

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/copy_module.html#ansible-collections-ansible-builtin-copy-module

```
    - name: Copy file with owner and permissions
      ansible.builtin.copy:
        src: /srv/myfiles/foo.conf
        dest: /etc/foo.conf
        owner: foo
        group: foo
        mode: '0644'

    - name: Copy file with owner and permission, using symbolic representation
      ansible.builtin.copy:
        src: /srv/myfiles/foo.conf
        dest: /etc/foo.conf
        owner: foo
        group: foo
        mode: u=rw,g=r,o=r

    - name: Another symbolic mode example, adding some permissions and removing others
      ansible.builtin.copy:
        src: /srv/myfiles/foo.conf
        dest: /etc/foo.conf
        owner: foo
        group: foo
        mode: u+rw,g-wx,o-rwx

    - name: Copy a new "ntp.conf" file into place, backing up the original if it differs from the copied version
      ansible.builtin.copy:
        src: /mine/ntp.conf
        dest: /etc/ntp.conf
        owner: root
        group: root
        mode: '0644'
        backup: yes

    - name: Copy a new "sudoers" file into place, after passing validation with visudo
      ansible.builtin.copy:
        src: /mine/sudoers
        dest: /etc/sudoers
        validate: /usr/sbin/visudo -csf %s

    - name: Copy a "sudoers" file on the remote machine for editing
      ansible.builtin.copy:
        src: /etc/sudoers
        dest: /etc/sudoers.edit
        remote_src: yes
        validate: /usr/sbin/visudo -csf %s

    - name: Copy using inline content
      ansible.builtin.copy:
        content: '# This file was moved to /etc/other.conf'
        dest: /etc/mine.conf

    - name: If follow=yes, /path/to/file will be overwritten by contents of foo.conf
      ansible.builtin.copy:
        src: /etc/foo.conf
        dest: /path/to/link  # link to /path/to/file
        follow: yes

    - name: If follow=no, /path/to/link will become a file and be overwritten by contents of foo.conf
      ansible.builtin.copy:
        src: /etc/foo.conf
        dest: /path/to/link  # link to /path/to/file
        follow: no
```

# Fetch files from remote nodes

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/fetch_module.html#ansible-collections-ansible-builtin-fetch-module

```
    - name: Store file into /tmp/fetched/host.example.com/tmp/somefile
      ansible.builtin.fetch:
        src: /tmp/somefile
        dest: /tmp/fetched

    - name: Specifying a path directly
      ansible.builtin.fetch:
        src: /tmp/somefile
        dest: /tmp/prefix-{{ inventory_hostname }}
        flat: yes

    - name: Specifying a destination path
      ansible.builtin.fetch:
        src: /tmp/uniquefile
        dest: /tmp/special/
        flat: yes

    - name: Storing in a path relative to the playbook
      ansible.builtin.fetch:
        src: /tmp/uniquefile
        dest: special/prefix-{{ inventory_hostname }}
        flat: yes
```

# Execute shell commands on targets

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/shell_module.html#ansible-collections-ansible-builtin-shell-module

```
    - name: Execute the command in remote shell; stdout goes to the specified file on the remote
      ansible.builtin.shell: somescript.sh >> somelog.txt

    - name: Change the working directory to somedir/ before executing the command
      ansible.builtin.shell: somescript.sh >> somelog.txt
      args:
        chdir: somedir/

    # You can also use the 'args' form to provide the options.
    - name: This command will change the working directory to somedir/ and will only run when somedir/somelog.txt doesn't exist
      ansible.builtin.shell: somescript.sh >> somelog.txt
      args:
        chdir: somedir/
        creates: somelog.txt

    # You can also use the 'cmd' parameter instead of free form format.
    - name: This command will change the working directory to somedir/
      ansible.builtin.shell:
        cmd: ls -l | grep log
        chdir: somedir/

    - name: Run a command that uses non-posix shell-isms (in this example /bin/sh doesn't handle redirection and wildcards together but bash does)
      ansible.builtin.shell: cat < /tmp/*txt
      args:
        executable: /bin/bash

    - name: Run a command using a templated variable (always use quote filter to avoid injection)
      ansible.builtin.shell: cat {{ myfile|quote }}

    # You can use shell to run other executables to perform actions inline
    - name: Run expect to wait for a successful PXE boot via out-of-band CIMC
      ansible.builtin.shell: |
        set timeout 300
        spawn ssh admin@{{ cimc_host }}

        expect "password:"
        send "{{ cimc_password }}\n"

        expect "\n{{ cimc_name }}"
        send "connect host\n"

        expect "pxeboot.n12"
        send "\n"

        exit 0
      args:
        executable: /usr/bin/expect
      delegate_to: localhost
```

# Manage lines in text files

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/lineinfile_module.html#ansible-collections-ansible-builtin-lineinfile-module

```
    # NOTE: Before 2.3, option 'dest', 'destfile' or 'name' was used instead of 'path'
    - name: Ensure SELinux is set to enforcing mode
      ansible.builtin.lineinfile:
        path: /etc/selinux/config
        regexp: '^SELINUX='
        line: SELINUX=enforcing

    - name: Make sure group wheel is not in the sudoers configuration
      ansible.builtin.lineinfile:
        path: /etc/sudoers
        state: absent
        regexp: '^%wheel'

    - name: Replace a localhost entry with our own
      ansible.builtin.lineinfile:
        path: /etc/hosts
        regexp: '^127\.0\.0\.1'
        line: 127.0.0.1 localhost
        owner: root
        group: root
        mode: '0644'

    - name: Replace a localhost entry searching for a literal string to avoid escaping
      ansible.builtin.lineinfile:
        path: /etc/hosts
        search_string: '127.0.0.1'
        line: 127.0.0.1 localhost
        owner: root
        group: root
        mode: '0644'

    - name: Ensure the default Apache port is 8080
      ansible.builtin.lineinfile:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^Listen '
        insertafter: '^#Listen '
        line: Listen 8080

    - name: Ensure php extension matches new pattern
      ansible.builtin.lineinfile:
        path: /etc/httpd/conf/httpd.conf
        search_string: '<FilesMatch ".php[45]?$">'
        insertafter: '^\t<Location \/>\n'
        line: '        <FilesMatch ".php[34]?$">'

    - name: Ensure we have our own comment added to /etc/services
      ansible.builtin.lineinfile:
        path: /etc/services
        regexp: '^# port for http'
        insertbefore: '^www.*80/tcp'
        line: '# port for http by default'

    - name: Add a line to a file if the file does not exist, without passing regexp
      ansible.builtin.lineinfile:
        path: /tmp/testfile
        line: 192.168.1.99 foo.lab.net foo
        create: yes

    # NOTE: Yaml requires escaping backslashes in double quotes but not in single quotes
    - name: Ensure the JBoss memory settings are exactly as needed
      ansible.builtin.lineinfile:
        path: /opt/jboss-as/bin/standalone.conf
        regexp: '^(.*)Xms(\d+)m(.*)$'
        line: '\1Xms${xms}m\3'
        backrefs: yes

    # NOTE: Fully quoted because of the ': ' on the line. See the Gotchas in the YAML docs.
    - name: Validate the sudoers file before saving
      ansible.builtin.lineinfile:
        path: /etc/sudoers
        state: present
        regexp: '^%ADMIN ALL='
        line: '%ADMIN ALL=(ALL) NOPASSWD: ALL'
        validate: /usr/sbin/visudo -cf %s

    # See https://docs.python.org/3/library/re.html for further details on syntax
    - name: Use backrefs with alternative group syntax to avoid conflicts with variable values
      ansible.builtin.lineinfile:
        path: /tmp/config
        regexp: ^(host=).*
        line: \g<1>{{ hostname }}
        backrefs: yes
```

# Insert/update/remove a text block surrounded by marker lines

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/blockinfile_module.html#ansible-collections-ansible-builtin-blockinfile-module

```
    # Before Ansible 2.3, option 'dest' or 'name' was used instead of 'path'
    - name: Insert/Update "Match User" configuration block in /etc/ssh/sshd_config prepending and appending a new line
      ansible.builtin.blockinfile:
        path: /etc/ssh/sshd_config
        append_newline: true
        prepend_newline: true
        block: |
          Match User ansible-agent
          PasswordAuthentication no

    - name: Insert/Update eth0 configuration stanza in /etc/network/interfaces
            (it might be better to copy files into /etc/network/interfaces.d/)
      ansible.builtin.blockinfile:
        path: /etc/network/interfaces
        block: |
          iface eth0 inet static
              address 192.0.2.23
              netmask 255.255.255.0

    - name: Insert/Update configuration using a local file and validate it
      ansible.builtin.blockinfile:
        block: "{{ lookup('ansible.builtin.file', './local/sshd_config') }}"
        path: /etc/ssh/sshd_config
        backup: yes
        validate: /usr/sbin/sshd -T -f %s

    - name: Insert/Update HTML surrounded by custom markers after <body> line
      ansible.builtin.blockinfile:
        path: /var/www/html/index.html
        marker: "<!-- {mark} ANSIBLE MANAGED BLOCK -->"
        insertafter: "<body>"
        block: |
          <h1>Welcome to {{ ansible_hostname }}</h1>
          <p>Last updated on {{ ansible_date_time.iso8601 }}</p>

    - name: Remove HTML as well as surrounding markers
      ansible.builtin.blockinfile:
        path: /var/www/html/index.html
        marker: "<!-- {mark} ANSIBLE MANAGED BLOCK -->"
        block: ""

    - name: Add mappings to /etc/hosts
      ansible.builtin.blockinfile:
        path: /etc/hosts
        block: |
          {{ item.ip }} {{ item.name }}
        marker: "# {mark} ANSIBLE MANAGED BLOCK {{ item.name }}"
      loop:
        - { name: host1, ip: 10.10.1.10 }
        - { name: host2, ip: 10.10.1.11 }
        - { name: host3, ip: 10.10.1.12 }

    - name: Search with a multiline search flags regex and if found insert after
      blockinfile:
        path: listener.ora
        block: "{{ listener_line | indent(width=8, first=True) }}"
        insertafter: '(?m)SID_LIST_LISTENER_DG =\n.*\(SID_LIST ='
        marker: "    <!-- {mark} ANSIBLE MANAGED BLOCK -->"
```

# Print statements during execution (aka debug)

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/debug_module.html#ansible-collections-ansible-builtin-debug-module

```
    - name: Print the gateway for each host when defined
      ansible.builtin.debug:
        msg: System {{ inventory_hostname }} has gateway {{ ansible_default_ipv4.gateway }}
      when: ansible_default_ipv4.gateway is defined

    - name: Get uptime information
      ansible.builtin.shell: /usr/bin/uptime
      register: result

    - name: Print return information from the previous task
      ansible.builtin.debug:
        var: result
        verbosity: 2

    - name: Display all variables/facts known for a host
      ansible.builtin.debug:
        var: hostvars[inventory_hostname]
        verbosity: 4

    - name: Prints two lines of messages, but only if there is an environment value set
      ansible.builtin.debug:
        msg:
        - "Provisioning based on YOUR_KEY which is: {{ lookup('ansible.builtin.env', 'YOUR_KEY') }}"
        - "These servers were built using the password of '{{ password_used }}'. Please retain this for later use."
```

# Set host variable(s) and fact(s)

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/set_fact_module.html#ansible-collections-ansible-builtin-set-fact-module

```
    - name: Setting host facts using key=value pairs, this format can only create strings or booleans
      ansible.builtin.set_fact: one_fact="something" other_fact="{{ local_var }}"

    - name: Setting host facts using complex arguments
      ansible.builtin.set_fact:
        one_fact: something
        other_fact: "{{ local_var * 2 }}"
        another_fact: "{{ some_registered_var.results | map(attribute='ansible_facts.some_fact') | list }}"

    - name: Setting facts so that they will be persisted in the fact cache
      ansible.builtin.set_fact:
        one_fact: something
        other_fact: "{{ local_var * 2 }}"
        cacheable: yes

    - name: Creating list and dictionary variables
      ansible.builtin.set_fact:
        one_dict:
            something: here
            other: there
        one_list:
            - a
            - b
            - c
    # As of Ansible 1.8, Ansible will convert boolean strings ('true', 'false', 'yes', 'no')
    # to proper boolean values when using the key=value syntax, however it is still
    # recommended that booleans be set using the complex argument style:
    - name: Setting booleans using complex argument style
      ansible.builtin.set_fact:
        one_fact: yes
        other_fact: no

    - name: Creating list and dictionary variables using 'shorthand' YAML
      ansible.builtin.set_fact:
        two_dict: {'something': here2, 'other': somewhere}
        two_list: [1,2,3]
```

# Send e-mail

https://docs.ansible.com/projects/ansible/latest/collections/community/general/mail_module.html

```
    - name: Example playbook sending mail to root
      community.general.mail:
        subject: System {{ ansible_hostname }} has been successfully provisioned.
      delegate_to: localhost

    - name: Sending an e-mail using Gmail SMTP servers
      community.general.mail:
        host: smtp.gmail.com
        port: 587
        username: username@gmail.com
        password: mysecret
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: System {{ ansible_hostname }} has been successfully provisioned.
      delegate_to: localhost

    - name: Send e-mail to a bunch of users, attaching files
      community.general.mail:
        host: 127.0.0.1
        port: 2025
        subject: Ansible-report
        body: Hello, this is an e-mail. I hope you like it ;-)
        from: jane@example.net (Jane Jolie)
        to:
          - John Doe <j.d@example.org>
          - Suzie Something <sue@example.com>
        cc: Charlie Root <root@localhost>
        attach:
          - /etc/group
          - /tmp/avatar2.png
        headers:
          - Reply-To=john@example.com
          - X-Special="Something or other"
        charset: us-ascii
      delegate_to: localhost

    - name: Sending an e-mail using the remote machine, not the Ansible controller node
      community.general.mail:
        host: localhost
        port: 25
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: System {{ ansible_hostname }} has been successfully provisioned.

    - name: Sending an e-mail using Legacy SSL to the remote machine
      community.general.mail:
        host: localhost
        port: 25
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: System {{ ansible_hostname }} has been successfully provisioned.
        secure: always

    - name: Sending an e-mail using StartTLS to the remote machine
      community.general.mail:
        host: localhost
        port: 25
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: System {{ ansible_hostname }} has been successfully provisioned.
        secure: starttls

    - name: Sending an e-mail using StartTLS, remote server, custom EHLO, and timeout of 10 seconds
      community.general.mail:
        host: some.smtp.host.tld
        port: 25
        timeout: 10
        ehlohost: my-resolvable-hostname.tld
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: System {{ ansible_hostname }} has been successfully provisioned.
        secure: starttls
```

# Manages packages with the dnf package manager

https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/dnf_module.html

```
    - name: Install the latest version of Apache
      ansible.builtin.dnf:
        name: httpd
        state: latest

    - name: Install Apache >= 2.4
      ansible.builtin.dnf:
        name: httpd >= 2.4
        state: present

    - name: Install the latest version of Apache and MariaDB
      ansible.builtin.dnf:
        name:
          - httpd
          - mariadb-server
        state: latest

    - name: Remove the Apache package
      ansible.builtin.dnf:
        name: httpd
        state: absent

    - name: Install the latest version of Apache from the testing repo
      ansible.builtin.dnf:
        name: httpd
        enablerepo: testing
        state: present

    - name: Upgrade all packages
      ansible.builtin.dnf:
        name: "*"
        state: latest

    - name: Update the webserver, depending on which is installed on the system. Do not install the other one
      ansible.builtin.dnf:
        name:
          - httpd
          - nginx
        state: latest
        update_only: yes

    - name: Install the nginx rpm from a remote repo
      ansible.builtin.dnf:
        name: 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm'
        state: present

    - name: Install nginx rpm from a local file
      ansible.builtin.dnf:
        name: /usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm
        state: present

    - name: Install Package based upon the file it provides
      ansible.builtin.dnf:
        name: /usr/bin/cowsay
        state: present

    - name: Install the 'Development tools' package group
      ansible.builtin.dnf:
        name: '@Development tools'
        state: present

    - name: Autoremove unneeded packages installed as dependencies
      ansible.builtin.dnf:
        autoremove: yes

    - name: Uninstall httpd but keep its dependencies
      ansible.builtin.dnf:
        name: httpd
        state: absent
        autoremove: no

    - name: Install a modularity appstream with defined stream and profile
      ansible.builtin.dnf:
        name: '@postgresql:9.6/client'
        state: present

    - name: Install a modularity appstream with defined stream
      ansible.builtin.dnf:
        name: '@postgresql:9.6'
        state: present

    - name: Install a modularity appstream with defined profile
      ansible.builtin.dnf:
        name: '@postgresql/client'
        state: present
```

# 自己备份的7.1.1，以劫持依赖，以下为安装脚本

Debian安装命令：

<pre><code class="language-bash">wget -O install.sh https://raw.githubusercontent.com/cq520/bt/master/7.1.1/zj/install/install-ubuntu_6.0.sh && bash install.sh</code></pre>


Centos安装脚本：

<pre><code class="language-bash">yum install -y wget && wget -O install.sh https://raw.githubusercontent.com/cq520/bt/master/7.1.1/zj/install/install_6.0.sh && sh install.sh</code></pre>

Ubuntu/Deepin安装命令：

<pre><code class="language-bash">wget -O install.sh https://raw.githubusercontent.com/cq520/bt/master/7.1.1/zj/install/install-ubuntu_6.0.sh && sudo bash install.sh</code></pre>

Nginx防火墙安装命令：

<pre><code class="language-bash">wget -O btwaf.sh https://raw.githubusercontent.com/cq520/bt/master/7.1.1/zj/install/btwaf.sh && sudo bash btwaf.sh</code></pre>
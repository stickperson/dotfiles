from subprocess import run


INSTALL_CONFIGS = {
    'mac': ['mac.sh'],
    'pi': ['pi.sh']
}


def run_command(*args):
    res = run(args, check=True, capture_output=True, encoding='utf8')
    return res.stdout.lower()


if __name__ == '__main__':
    output = run_command('uname', '-a')
    system = None

    if 'darwin' in output:
        system = 'mac'
    elif 'raspberrypi' in output:
        system = 'pi'

    if system:
        for script in INSTALL_CONFIGS[system]:
            path = f'scripts/{script}'
            run_command('sh', path)
    run_command('./init.sh')

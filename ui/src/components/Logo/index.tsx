import classNames from 'classnames';
import logo from './logo.png';
import { useEffect, useState } from 'react';

const Logo: GenieType.FC<{
  hideSplit?: boolean;
}> = (props) => {
  const { className, hideSplit } = props;
  const [username, setUsername] = useState('学生');

  useEffect(() => {
    // 从URL参数中获取用户名
    const urlParams = new URLSearchParams(window.location.search);
    const usernameParam = urlParams.get('username');

    if (usernameParam && usernameParam !== 'anonymous') {
      setUsername(usernameParam);
    }
  }, []);

  return <div className={classNames('flex items-center', className)}>
    <img src={logo} alt="logo" width={20}/>
    <div
      className='ml-8 text-lg font-bold text-transparent bg-clip-text text-[16px]'
      style={{backgroundImage: 'linear-gradient(270deg, rgba(130,45,255,1) 0%,rgba(62,69,255,1) 20.88266611099243%,rgba(60,196,250,1) 100%)'}}
    >{username}</div>
    {!hideSplit && <div className='w-1 h-16 mx-8 bg-[#dbdbde]'></div>}
  </div>;
};

export default Logo;

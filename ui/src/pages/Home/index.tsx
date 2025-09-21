import { useState, useCallback, memo } from "react";
import GeneralInput from "@/components/GeneralInput";
import Slogn from "@/components/Slogn";
import ChatView from "@/components/ChatView";
import { productList, defaultProduct } from "@/utils/constants";

type HomeProps = Record<string, never>;

const Home: GenieType.FC<HomeProps> = memo(() => {
  const [inputInfo, setInputInfo] = useState<CHAT.TInputInfo>({
    message: "",
    deepThink: false,
  });
  const [product, setProduct] = useState(defaultProduct);

  const changeInputInfo = useCallback((info: CHAT.TInputInfo) => {
    setInputInfo(info);
  }, []);


  const renderContent = () => {
    if (inputInfo.message.length === 0) {
      return (
        <div className="pt-[120px] flex flex-col items-center">
          <Slogn />
          <div className="w-640 rounded-xl shadow-[0_18px_39px_0_rgba(198,202,240,0.1)]">
            <GeneralInput
              placeholder={product.placeholder}
              showBtn={true}
              size="big"
              disabled={false}
              product={product}
              send={changeInputInfo}
            />
          </div>
          <div className="w-640 flex flex-wrap gap-16 mt-[16px]">
            {productList.map((item, i) => (
              <div
                key={i}
                className={`w-[22%] h-[36px] cursor-pointer flex items-center justify-center border rounded-[8px] ${item.type === product.type ? "border-[#4040ff] bg-[rgba(64,64,255,0.02)] text-[#4040ff]" : "border-[#E9E9F0] text-[#666]"}`}
                onClick={() => setProduct(item)}
              >
                <i className={`font_family ${item.img} ${item.color}`}></i>
                <div className="ml-[6px]">{item.name}</div>
              </div>
            ))}
          </div>
          {/* <div className="mt-80 mb-120">
            <div className="text-center">
              <h2 className="text-2xl font-bold mb-2">优秀案例</h2>
              <p className="text-gray-500">和 Genie 一起提升工作效率</p>
            </div>
            <div className="flex gap-16 mt-24">
              {demoList.map((demo, i) => (
                <CaseCard key={i} {...demo} />
              ))}
            </div>
          </div> */}
        </div>
      );
    }
    return <ChatView inputInfo={inputInfo} product={product} />;
  };

  return (
    <div className="h-full flex flex-col items-center ">
      {renderContent()}
    </div>
  );
});

Home.displayName = "Home";

export default Home;

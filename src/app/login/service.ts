import axios from 'axios';


export const login = async (email: string, password: string) => {
  try {  
    const apiUrl = process.env.NEXT_PUBLIC_AUTH_API_URL + '/v1/auth/login';
    const response = await axios.post(apiUrl, { email, password });
    const { accessToken, user } = response.data;

    localStorage.setItem('token', accessToken);
    localStorage.setItem('user', JSON.stringify(user));

    return { accessToken, user };
 } catch (error) {
    if (axios.isAxiosError(error) && error.response) {
      throw new Error(error.response.data.message || "Erro ao fazer login");
    } else {
      throw new Error("Erro de conexão");
    }
  }
};
